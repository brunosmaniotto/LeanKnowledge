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
import sys
import time
from pathlib import Path

# Ensure the project source is importable
sys.path.insert(0, str(Path(__file__).resolve().parents[1] / "src"))

from leanknowledge.proofwiki import load_proofwiki, dataset_stats
from leanknowledge.pipeline import Pipeline, PipelineResult
from leanknowledge.backlog import BacklogEntry, BacklogStatus
from leanknowledge.agents.triage import ItemCategory


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
    parser.add_argument("--stats-only", action="store_true", help="Print dataset stats and exit")
    parser.add_argument("--load-only", action="store_true",
                        help="Load into backlog and save, don't formalize")
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
    items = load_proofwiki(
        data_path,
        with_proof_only=True,
        categories=args.category,
        max_items=args.max,
    )
    print(f"  Loaded {len(items)} theorems")

    # Set up pipeline
    output_dir = Path(args.output)
    pipeline = Pipeline(
        lean_project_dir=Path(args.lean_project) if args.lean_project else None,
        output_dir=output_dir,
    )

    # Load existing backlog if resuming
    backlog_path = Path(args.backlog) if args.backlog else (output_dir / "backlog.json")
    pipeline.load_backlog(backlog_path)

    # Populate backlog directly (skip Agents 1-4)
    added = populate_backlog(pipeline, items)
    stats = pipeline.backlog.stats
    print(f"  Added {added} new items to backlog")
    print(f"  Backlog: {stats}")

    pipeline.save_backlog(backlog_path)

    if args.load_only:
        print("Load-only mode — backlog saved, exiting.")
        return

    # Run formalization
    print(f"\n{'=' * 60}")
    print(f"Starting formalization...")
    print(f"{'=' * 60}\n")

    start = time.time()
    results = run_batch(pipeline, max_failures=args.max_failures)
    elapsed = time.time() - start

    # Save backlog after run
    pipeline.save_backlog(backlog_path)

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


if __name__ == "__main__":
    main()
