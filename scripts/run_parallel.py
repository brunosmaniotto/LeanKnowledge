"""Launch parallel ProofWiki formalization workers with a shared work pool.

Usage:
    # 10 workers, 1000 theorems, pool-based (workers pull from shared queue)
    python scripts/run_parallel.py \
        --data data/proofwiki.json \
        --workers 10 --total 1000 \
        --lean-project ~/lean-project \
        --output outputs/run7

Workers pull theorems one-at-a-time from a shared queue file. Fast workers
automatically pick up slack from slow ones — no pre-assigned batches.

Each worker gets a unique scratch file (Scratch_0.lean, Scratch_1.lean, etc.)
and writes to its own output subdirectory.
"""

import argparse
import json
import os
import subprocess
import sys
import time
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parents[1] / "src"))


def build_queue(data_path, total, categories):
    """Load ProofWiki items and build a queue of theorem IDs."""
    from leanknowledge.proofwiki import load_proofwiki

    items = load_proofwiki(
        data_path,
        with_proof_only=True,
        categories=categories,
        max_items=total,
    )
    # Return list of (index_in_dataset, item_id) — we need the index so
    # workers can load the same item by position
    return [(i, item.id) for i, item in enumerate(items)]


def main():
    parser = argparse.ArgumentParser(description="Parallel ProofWiki formalization")
    parser.add_argument("--data", required=True, help="Path to proofwiki.json")
    parser.add_argument("--lean-project", required=True, help="Path to Lake project")
    parser.add_argument("--output", default="outputs/parallel", help="Output base directory")
    parser.add_argument("--workers", type=int, default=10, help="Number of parallel workers")
    parser.add_argument("--total", type=int, default=150, help="Total theorems to formalize")
    parser.add_argument("--category", action="append", default=None, help="Category filter (repeatable)")
    parser.add_argument("--max-failures", type=int, default=50, help="Max consecutive failures per worker")
    parser.add_argument("--identifiers", default=None,
                        help="Path to shared confirmed_identifiers.json (cross-run learning)")
    parser.add_argument("--analyze", action="store_true",
                        help="Run Supervisor analysis after all workers finish")
    parser.add_argument("--analyze-llm", action="store_true",
                        help="Run Supervisor with LLM-powered Phase 4 (implies --analyze)")
    args = parser.parse_args()

    output_base = Path(args.output)
    output_base.mkdir(parents=True, exist_ok=True)

    # Build shared work queue
    data_path = Path(args.data)
    print(f"Building work queue from {data_path}...")
    queue_items = build_queue(data_path, args.total, args.category)
    print(f"  {len(queue_items)} theorems loaded")

    # Write queue file — each entry is {index, id, status}
    queue_path = output_base / "work_queue.json"
    queue_data = {
        "items": [
            {"index": idx, "id": item_id, "status": "pending", "worker": None}
            for idx, item_id in queue_items
        ],
    }
    queue_path.write_text(json.dumps(queue_data, indent=2), encoding="utf-8")

    # Build category flags
    cat_flags = []
    if args.category:
        for c in args.category:
            cat_flags.extend(["--category", c])

    print(f"\nLaunching {args.workers} workers (pool mode)")
    print(f"  Queue: {len(queue_items)} theorems in {queue_path}")
    print(f"  Output: {output_base}/worker_N/")
    print()

    processes = []
    log_files = []

    for i in range(args.workers):
        worker_output = output_base / f"worker_{i}"
        log_path = output_base / f"worker_{i}.log"

        cmd = [
            sys.executable, "-u",
            str(Path(__file__).parent / "run_proofwiki.py"),
            "--data", args.data,
            "--lean-project", args.lean_project,
            "--output", str(worker_output),
            "--worker-id", str(i),
            "--pool", str(queue_path),
            "--max-failures", str(args.max_failures),
        ]
        if args.identifiers:
            cmd.extend(["--identifiers", args.identifiers])
        cmd += cat_flags

        log_file = open(log_path, "w")
        log_files.append(log_file)

        proc = subprocess.Popen(
            cmd,
            stdout=log_file,
            stderr=subprocess.STDOUT,
            env=os.environ.copy(),
        )
        processes.append((i, proc, log_path))
        print(f"  Worker {i}: PID {proc.pid}, log: {log_path}")

    print(f"\nAll {len(processes)} workers launched. Monitoring...\n")

    # Monitor until all done
    completed = set()
    while len(completed) < len(processes):
        time.sleep(30)
        status_parts = []

        # Read queue to get global progress
        try:
            qdata = json.loads(queue_path.read_text(encoding="utf-8"))
            done_count = sum(1 for it in qdata["items"] if it["status"] in ("done", "failed", "error"))
            pending_count = sum(1 for it in qdata["items"] if it["status"] == "pending")
            in_progress = sum(1 for it in qdata["items"] if it["status"] == "claimed")
        except Exception:
            done_count = pending_count = in_progress = "?"

        for i, proc, log_path in processes:
            if i in completed:
                continue
            ret = proc.poll()
            if ret is not None:
                completed.add(i)
                status_parts.append(f"W{i}:DONE(rc={ret})")
            else:
                # Count successes/failures from log
                try:
                    log_text = log_path.read_text()
                    s = log_text.count("=== SUCCESS")
                    f = log_text.count("=== FAILED")
                    status_parts.append(f"W{i}:{s}ok/{f}fail")
                except Exception:
                    status_parts.append(f"W{i}:running")

        now = time.strftime("%H:%M:%S")
        print(f"  [{now}] {' | '.join(status_parts)}  "
              f"(queue: {done_count} done, {in_progress} active, {pending_count} pending | "
              f"{len(completed)}/{len(processes)} workers done)")

    # Collect results
    print(f"\n{'=' * 60}")
    print(f"All workers finished!")
    print(f"{'=' * 60}\n")

    total_success = 0
    total_fail = 0
    total_error = 0
    for i, proc, log_path in processes:
        try:
            log_text = log_path.read_text()
            s = log_text.count("=== SUCCESS")
            f = log_text.count("=== FAILED")
            e = log_text.count("=== ERROR")
            total_success += s
            total_fail += f
            total_error += e
            print(f"  Worker {i}: {s} success, {f} failed, {e} error (rc={proc.returncode})")
        except Exception:
            print(f"  Worker {i}: could not read log")

    total = total_success + total_fail + total_error
    rate = total_success / total * 100 if total else 0
    print(f"\n  TOTAL: {total_success}/{total} = {rate:.0f}% success rate")
    if total_error:
        print(f"  ({total_error} errors — validation/crash, not translation failures)")

    # Final queue stats
    try:
        qdata = json.loads(queue_path.read_text(encoding="utf-8"))
        statuses = {}
        for it in qdata["items"]:
            statuses[it["status"]] = statuses.get(it["status"], 0) + 1
        print(f"\n  Queue final state: {statuses}")
    except Exception:
        pass

    # Merge confirmed identifiers from all workers into a shared file
    try:
        from collections import Counter
        merged = Counter()
        for i, _, _ in processes:
            ident_path = output_base / f"worker_{i}" / "confirmed_identifiers.json"
            if ident_path.exists():
                data = json.loads(ident_path.read_text(encoding="utf-8"))
                merged.update(data)
        if merged:
            merged_path = output_base / "confirmed_identifiers.json"
            merged_path.write_text(
                json.dumps(dict(merged.most_common()), indent=2),
                encoding="utf-8",
            )
            print(f"\n  Cross-run learning: {len(merged)} confirmed identifiers "
                  f"saved to {merged_path}")
            print(f"  Top 10: {', '.join(name for name, _ in merged.most_common(10))}")
    except Exception as e:
        print(f"\n  Warning: could not merge identifiers: {e}")

    # Merge Rosetta Stone entries from all workers
    try:
        merged_rosetta = output_base / "rosetta_stone.jsonl"
        entry_count = 0
        with open(merged_rosetta, "w", encoding="utf-8") as out:
            for i, _, _ in processes:
                worker_rosetta = output_base / f"worker_{i}" / "rosetta_stone.jsonl"
                if worker_rosetta.exists():
                    for line in worker_rosetta.read_text(encoding="utf-8").splitlines():
                        if line.strip():
                            out.write(line + "\n")
                            entry_count += 1
        if entry_count:
            print(f"  Rosetta Stone: {entry_count} new NL↔Lean pairs saved to {merged_rosetta}")
        else:
            merged_rosetta.unlink(missing_ok=True)
    except Exception as e:
        print(f"\n  Warning: could not merge Rosetta Stone: {e}")

    # Optional: run Supervisor analysis
    if args.analyze or args.analyze_llm:
        try:
            from leanknowledge.agents.supervisor import Supervisor

            print(f"\n{'=' * 60}")
            print(f"Running Supervisor analysis...")
            print(f"{'=' * 60}\n")

            supervisor = Supervisor(output_base)
            report = supervisor.analyze(use_llm=args.analyze_llm)
            supervisor.print_report(report)
            supervisor.save_report(report)
        except Exception as e:
            print(f"\n  Warning: Supervisor analysis failed: {e}")

    for lf in log_files:
        lf.close()


if __name__ == "__main__":
    main()
