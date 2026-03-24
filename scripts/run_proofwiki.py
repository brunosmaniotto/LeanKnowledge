"""Run the LeanKnowledge pipeline on ProofWiki theorems.

Usage:
    # Pilot: 10 theorems from Number Theory
    python scripts/run_proofwiki.py --data data/proofwiki.json --category "Number Theory" --max 10

    # All theorems with proofs from a specific category
    python scripts/run_proofwiki.py --data data/proofwiki.json --category "Topology"

    # Full run: all theorems with proofs
    python scripts/run_proofwiki.py --data data/proofwiki.json

    # Resume from existing backlog
    python scripts/run_proofwiki.py --data data/proofwiki.json --backlog outputs/proofwiki_backlog.json
"""

import argparse
import json
import re
import sys
import time
from pathlib import Path

if sys.platform == 'win32':
    import msvcrt
else:
    import fcntl

# Ensure the project source is importable
sys.path.insert(0, str(Path(__file__).resolve().parents[1] / "src"))

from leanknowledge.proofwiki import load_proofwiki, dataset_stats
from leanknowledge.pipeline import Pipeline, PipelineResult
from leanknowledge.backlog import BacklogEntry, BacklogStatus
from leanknowledge.agents.triage import ItemCategory


def _lock_file(f):
    """Cross-platform exclusive file lock."""
    if sys.platform == 'win32':
        # Lock first byte of file
        msvcrt.locking(f.fileno(), msvcrt.LK_LOCK, 1)
    else:
        fcntl.flock(f, fcntl.LOCK_EX)


def _unlock_file(f):
    """Cross-platform file unlock."""
    if sys.platform == 'win32':
        try:
            f.seek(0)
            msvcrt.locking(f.fileno(), msvcrt.LK_UNLCK, 1)
        except OSError:
            pass  # Already unlocked
    else:
        fcntl.flock(f, fcntl.LOCK_UN)


def populate_backlog(pipeline: Pipeline, items, skip_existing: bool = True) -> int:
    """Add ProofWiki items directly to backlog, skipping Agents 1-4."""
    added = 0
    for item in items:
        if skip_existing and pipeline.backlog.get(item.id) is not None:
            continue

        cat = ItemCategory.DEFINITION if item.type.value == "definition" else ItemCategory.THEOREM
        entry = BacklogEntry(item=item, category=cat)
        pipeline.backlog.add(entry)
        added += 1

    return added


def run_batch(pipeline: Pipeline, max_failures: int = 10) -> list[PipelineResult]:
    """Formalize all ready theorems, stopping after max_failures consecutive failures."""
    results = []
    consecutive_fails = 0

    while True:
        result = pipeline.formalize_next()
        if result is None:
            break

        results.append(result)

        if result.success:
            consecutive_fails = 0
        else:
            consecutive_fails += 1
            if consecutive_fails >= max_failures:
                print(f"\n{max_failures} consecutive failures — stopping batch.")
                break

    return results


# ---------------------------------------------------------------------------
# Pool mode — workers claim one theorem at a time from a shared queue file
# ---------------------------------------------------------------------------

def _claim_next(queue_path: Path, worker_id: int) -> dict | None:
    """Atomically claim the next pending item from the shared queue.

    Uses file locking (fcntl.flock) so multiple workers can safely share
    one queue file. Returns the claimed item dict or None if queue empty.
    """
    with open(queue_path, "r+", encoding="utf-8") as f:
        _lock_file(f)
        try:
            data = json.loads(f.read())
            for item in data["items"]:
                if item["status"] == "pending":
                    item["status"] = "claimed"
                    item["worker"] = worker_id
                    f.seek(0)
                    f.write(json.dumps(data, indent=2))
                    f.truncate()
                    return item
            return None
        finally:
            _unlock_file(f)


def _update_queue(queue_path: Path, item_id: str, status: str,
                   bump_retries: bool = False,
                   failure_type: str | None = None,
                   error_summary: str | None = None,
                   attempts: int | None = None) -> int:
    """Update the status of an item in the shared queue.

    Args:
        failure_type: Classification when status='failed'. One of:
            'genuine' — all tiers exhausted, real proof difficulty
            'crash' — exception/network error during formalization
            'not_found' — item ID not in loaded dataset
        error_summary: Short error description (first 200 chars)
        attempts: Number of LLM attempts made

    Returns the current retry count for this item.
    """
    retries = 0
    with open(queue_path, "r+", encoding="utf-8") as f:
        _lock_file(f)
        try:
            data = json.loads(f.read())
            for item in data["items"]:
                if item["id"] == item_id:
                    item["status"] = status
                    if bump_retries:
                        item["retries"] = item.get("retries", 0) + 1
                    retries = item.get("retries", 0)
                    if failure_type:
                        item["failure_type"] = failure_type
                    if error_summary:
                        item["error_summary"] = error_summary[:200]
                    if attempts is not None:
                        item["attempts"] = attempts
                    break
            f.seek(0)
            f.write(json.dumps(data, indent=2))
            f.truncate()
        finally:
            _unlock_file(f)
    return retries


# Patterns that indicate operational (non-proof) failures
_OPERATIONAL_COMPILER_RE = re.compile(
    r"object file.*does not exist"
    r"|unknown module"
    r"|could not find module",
    re.IGNORECASE,
)

# Max times an item can be auto-requeued before being marked as a real failure
MAX_AUTO_RETRIES = 3


def _is_operational_failure(result: "PipelineResult") -> bool:
    """Check if a failed result was caused by an operational issue, not proof difficulty.

    Operational failures (missing olean, module not found, no triples produced)
    should be requeued rather than counted as genuine proof failures.
    """
    if result.success:
        return False

    tr = result.translation
    if tr is None or not tr.triples:
        # No triples at all — pipeline crashed or LLM returned nothing parseable.
        # Treat as operational so it gets another chance.
        return True

    # Check if the last compiler error is an infrastructure issue
    last_err = tr.triples[-1].compiler_output or ""
    if _OPERATIONAL_COMPILER_RE.search(last_err):
        return True

    return False


def _recover_stuck_claims(queue_path: Path, max_age_seconds: int = 3600) -> int:
    """Reset any 'claimed' items stuck longer than max_age_seconds back to 'pending'.

    Prevents orphaned items when workers crash mid-formalization. Only resets items
    that have been claimed for longer than max_age_seconds (default 1 hour).
    """
    import os

    recovered = 0
    mtime = os.path.getmtime(queue_path)
    now = time.time()

    with open(queue_path, "r+", encoding="utf-8") as f:
        _lock_file(f)
        try:
            data = json.loads(f.read())
            for item in data["items"]:
                if item["status"] == "claimed":
                    # Use file mtime as a rough proxy for how long claims have been sitting
                    claimed_age = now - mtime
                    if claimed_age > max_age_seconds:
                        item["status"] = "pending"
                        if "worker" in item:
                            del item["worker"]
                        recovered += 1
                # Also recover any legacy "error" items — treat as retryable
                elif item["status"] == "error":
                    item["status"] = "pending"
                    recovered += 1
            if recovered > 0:
                f.seek(0)
                f.write(json.dumps(data, indent=2))
                f.truncate()
        finally:
            _unlock_file(f)
    return recovered


def run_pool(pipeline: Pipeline, all_items: list, queue_path: Path,
             worker_id: int, max_failures: int = 50) -> list[PipelineResult]:
    """Pool-based formalization — pull one theorem at a time from shared queue."""
    # Recover any stuck claims or error items from previous runs
    recovered = _recover_stuck_claims(queue_path)
    if recovered > 0:
        print(f"  [W{worker_id}] Recovered {recovered} stuck/error items back to pending")

    # Build lookup: item_id → ExtractedItem
    item_lookup = {item.id: item for item in all_items}

    results = []
    consecutive_fails = 0

    while True:
        claimed = _claim_next(queue_path, worker_id)
        if claimed is None:
            print(f"  Queue empty — worker {worker_id} done.")
            break

        item_id = claimed["id"]
        item = item_lookup.get(item_id)
        if item is None:
            print(f"  Warning: item {item_id} not found in dataset (index {claimed.get('index')}), skipping")
            _update_queue(queue_path, item_id, "failed",
                          failure_type="not_found",
                          error_summary="Item not found in loaded dataset")
            result = PipelineResult(item_id=item_id, success=False,
                                    error="Item not found in loaded dataset")
            results.append(result)
            continue

        # Add to this worker's backlog and formalize
        cat = ItemCategory.DEFINITION if item.type.value == "definition" else ItemCategory.THEOREM
        entry = BacklogEntry(item=item, category=cat)
        pipeline.backlog.add(entry)

        try:
            result = pipeline.formalize_entry(entry)
        except KeyboardInterrupt:
            # Don't swallow Ctrl+C — requeue item so another worker can pick it up
            _update_queue(queue_path, item_id, "pending")
            raise
        except Exception as e:
            # ALL exceptions are treated as operational failures and requeued.
            # The item goes back to "pending" as if it was never attempted,
            # up to MAX_AUTO_RETRIES times. After that, mark as "failed".
            # We never use "error" status — items are either retryable or genuinely failed.
            retries = _update_queue(queue_path, item_id, "pending",
                                    bump_retries=True)
            err_type = type(e).__name__
            if retries <= MAX_AUTO_RETRIES:
                print(f"  [W{worker_id}] Exception on {item_id} "
                      f"({err_type}, retry {retries}/{MAX_AUTO_RETRIES}), "
                      f"returning to pool: {str(e)[:100]}")
                time.sleep(30)  # back off before claiming next
                continue
            else:
                print(f"  [W{worker_id}] {item_id} exceeded {MAX_AUTO_RETRIES} "
                      f"retries ({err_type}), marking failed: {str(e)[:100]}")
                _update_queue(queue_path, item_id, "failed",
                              failure_type="crash",
                              error_summary=f"{err_type}: {str(e)[:180]}")
                result = PipelineResult(
                    item_id=item_id, success=False, error=f"{err_type}: {e}")

        results.append(result)

        if result.success:
            consecutive_fails = 0
            _update_queue(queue_path, item_id, "done")
        elif _is_operational_failure(result):
            # Operational failure — requeue instead of marking failed
            retries = _update_queue(queue_path, item_id, "pending",
                                    bump_retries=True)
            if retries <= MAX_AUTO_RETRIES:
                reason = "no triples" if (not result.translation or not result.translation.triples) else "operational compiler error"
                print(f"  [W{worker_id}] Operational failure on {item_id} "
                      f"({reason}, retry {retries}/{MAX_AUTO_RETRIES}), "
                      f"returning to pool")
                consecutive_fails = 0  # don't count against circuit breaker
            else:
                print(f"  [W{worker_id}] {item_id} exceeded {MAX_AUTO_RETRIES} "
                      f"operational retries, marking failed")
                attempts = result.translation.total_attempts if result.translation else 0
                err = result.error or "operational failure after retries"
                _update_queue(queue_path, item_id, "failed",
                              failure_type="crash",
                              error_summary=err[:200],
                              attempts=attempts)
                consecutive_fails += 1
                if consecutive_fails >= max_failures:
                    print(f"\n{max_failures} consecutive failures — worker {worker_id} stopping.")
                    break
        else:
            consecutive_fails += 1
            attempts = result.translation.total_attempts if result.translation else 0
            err = result.error or "all tiers exhausted"
            _update_queue(queue_path, item_id, "failed",
                          failure_type="genuine",
                          error_summary=err[:200],
                          attempts=attempts)
            if consecutive_fails >= max_failures:
                print(f"\n{max_failures} consecutive failures — worker {worker_id} stopping.")
                break

    return results


def print_summary(results: list[PipelineResult], elapsed: float) -> None:
    successes = sum(1 for r in results if r.success)
    failures = len(results) - successes
    total_attempts = sum(
        r.translation.total_attempts for r in results if r.translation
    )

    print(f"\n{'=' * 60}")
    print(f"ProofWiki Batch Results")
    print(f"{'=' * 60}")
    print(f"  Theorems attempted: {len(results)}")
    print(f"  Successes:          {successes} ({successes/len(results):.0%})" if results else "")
    print(f"  Failures:           {failures}")
    print(f"  Total LLM attempts: {total_attempts}")
    if successes:
        avg = total_attempts / successes
        print(f"  Avg attempts/success: {avg:.1f}")
    print(f"  Wall time:          {elapsed/60:.1f} min")
    print(f"{'=' * 60}")

    if results:
        # Per-theorem breakdown
        print(f"\nPer-theorem results:")
        for r in results:
            status = "OK" if r.success else "FAIL"
            attempts = r.translation.total_attempts if r.translation else 0
            err = ""
            if not r.success and r.error:
                err = f" — {r.error[:80]}"
            print(f"  [{status}] {r.item_id} ({attempts} attempts){err}")


def main():
    parser = argparse.ArgumentParser(description="Run LeanKnowledge on ProofWiki")
    parser.add_argument("--data", required=True, help="Path to naturalproofs_proofwiki.json")
    parser.add_argument("--lean-project", default=None, help="Path to Lake project (for Mathlib)")
    parser.add_argument("--output", default="outputs/proofwiki", help="Output directory")
    parser.add_argument("--backlog", default=None, help="Path to backlog JSON (for resume)")
    parser.add_argument("--category", action="append", default=None,
                        help="Filter to category (repeatable)")
    parser.add_argument("--max", type=int, default=None, help="Max theorems to load")
    parser.add_argument("--max-failures", type=int, default=10,
                        help="Stop after N consecutive failures")
    parser.add_argument("--worker-id", type=int, default=None,
                        help="Worker ID for parallel execution (unique scratch files)")
    parser.add_argument("--offset", type=int, default=0,
                        help="Skip first N theorems (for parallel splits)")
    parser.add_argument("--identifiers", default=None,
                        help="Path to shared confirmed_identifiers.json (cross-run learning)")
    parser.add_argument("--pool", default=None,
                        help="Path to shared work_queue.json (pool mode — claim one at a time)")
    parser.add_argument("--stats-only", action="store_true", help="Print dataset stats and exit")
    parser.add_argument("--load-only", action="store_true",
                        help="Load into backlog and save, don't formalize")
    parser.add_argument("--analyze", action="store_true",
                        help="Run Supervisor analysis after formalization completes")
    parser.add_argument("--analyze-llm", action="store_true",
                        help="Run Supervisor with LLM-powered Phase 4 (implies --analyze)")
    parser.add_argument("--mathlib-index", default=None,
                        help="Path to Mathlib declaration index JSON (for RAG + pre-compiler)")
    args = parser.parse_args()

    data_path = Path(args.data)
    if not data_path.exists():
        print(f"Dataset not found: {data_path}")
        print(f"Run: python scripts/download_proofwiki.py --output {data_path}")
        sys.exit(1)

    if args.stats_only:
        stats = dataset_stats(data_path)
        print(f"\n=== ProofWiki Dataset Stats ===")
        print(f"  Theorems:     {stats['theorems']:,}")
        print(f"  With proof:   {stats['with_proof']:,}")
        print(f"  Definitions:  {stats['definitions']:,}")
        print(f"  Others:       {stats['others']:,}")
        print(f"\n  Top categories:")
        for cat, count in stats["top_categories"]:
            print(f"    {cat}: {count}")
        return

    # Load items
    print(f"Loading ProofWiki data from {data_path}...")
    if args.pool:
        # Pool mode: load ALL items so any worker can claim any theorem
        # The queue file determines which items are available
        queue_data = json.loads(Path(args.pool).read_text(encoding="utf-8"))
        max_index = max(it["index"] for it in queue_data["items"]) + 1
        items = load_proofwiki(
            data_path,
            with_proof_only=True,
            categories=args.category,
            max_items=max_index,
        )
        print(f"  Loaded {len(items)} theorems (pool mode, worker {args.worker_id})")
    else:
        # Legacy fixed-batch mode
        load_max = (args.offset + args.max) if (args.offset and args.max) else args.max
        items = load_proofwiki(
            data_path,
            with_proof_only=True,
            categories=args.category,
            max_items=load_max,
        )
        # Apply offset for parallel splits
        if args.offset:
            items = items[args.offset:]
            if args.max:
                items = items[:args.max]
        print(f"  Loaded {len(items)} theorems"
              + (f" (offset={args.offset})" if args.offset else ""))

    # Set up pipeline
    output_dir = Path(args.output)
    pipeline = Pipeline(
        lean_project_dir=Path(args.lean_project) if args.lean_project else None,
        output_dir=output_dir,
        worker_id=args.worker_id,
    )

    # Load existing backlog if resuming (not used in pool mode)
    backlog_path = Path(args.backlog) if args.backlog else (output_dir / "backlog.json")
    if not args.pool:
        pipeline.load_backlog(backlog_path)

        # Populate backlog directly (skip Agents 1-4)
        added = populate_backlog(pipeline, items)
        stats = pipeline.backlog.stats
        print(f"  Added {added} new items to backlog")
        print(f"  Backlog: {stats}")

        pipeline.save_backlog(backlog_path)

    # Load confirmed identifiers from previous runs (cross-run learning)
    if args.identifiers:
        pipeline.load_identifiers(Path(args.identifiers))
    pipeline.load_identifiers()  # also load from output dir if exists

    # Load Mathlib declaration index for RAG + pre-compiler identifier validation
    if args.mathlib_index:
        pipeline.load_mathlib_index(Path(args.mathlib_index))

    # Load lessons from previous runs' triples
    triples_dir = output_dir / "triples"
    if triples_dir.exists():
        pipeline.tuner.ingest_triples_dir(triples_dir)
        tuner_stats = pipeline.tuner.stats
        print(f"  Prompt Tuner: loaded {tuner_stats['total_failures_ingested']} "
              f"past failures, {len(tuner_stats['triggered_rules'])} active rules, "
              f"{tuner_stats['confirmed_identifiers']} confirmed identifiers")

    if args.load_only:
        print("Load-only mode — backlog saved, exiting.")
        return

    # Run formalization
    print(f"\n{'=' * 60}")
    if args.pool:
        print(f"Starting formalization (pool mode, worker {args.worker_id})...")
    else:
        print(f"Starting formalization...")
    print(f"{'=' * 60}\n")

    start = time.time()
    if args.pool:
        results = run_pool(
            pipeline, items, Path(args.pool),
            worker_id=args.worker_id or 0,
            max_failures=args.max_failures,
        )
    else:
        results = run_batch(pipeline, max_failures=args.max_failures)
    elapsed = time.time() - start

    # Save backlog and confirmed identifiers after run
    pipeline.save_backlog(backlog_path)
    pipeline.save_identifiers()

    if results:
        print_summary(results, elapsed)

        # Save results summary
        summary_path = output_dir / "results_summary.json"
        summary_path.parent.mkdir(parents=True, exist_ok=True)
        summary = {
            "total": len(results),
            "successes": sum(1 for r in results if r.success),
            "failures": sum(1 for r in results if not r.success),
            "elapsed_seconds": elapsed,
            "items": [
                {
                    "id": r.item_id,
                    "success": r.success,
                    "attempts": r.translation.total_attempts if r.translation else 0,
                    "lean_file": r.lean_file,
                    "error": r.error,
                }
                for r in results
            ],
        }
        summary_path.write_text(json.dumps(summary, indent=2))
        print(f"\nResults saved to {summary_path}")
    else:
        print("No theorems to formalize.")

    # Optional: run Supervisor analysis
    if args.analyze or args.analyze_llm:
        try:
            from leanknowledge.agents.supervisor import Supervisor

            print(f"\n{'=' * 60}")
            print(f"Running Supervisor analysis...")
            print(f"{'=' * 60}\n")

            supervisor = Supervisor(output_dir)
            report = supervisor.analyze(use_llm=args.analyze_llm)
            supervisor.print_report(report)
            supervisor.save_report(report)
        except Exception as e:
            print(f"\n  Warning: Supervisor analysis failed: {e}")


if __name__ == "__main__":
    main()
