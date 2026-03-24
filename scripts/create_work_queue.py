"""Create a work queue for pool-based parallel formalization.

Usage:
    # First 1000 theorems (Run 7)
    python scripts/create_work_queue.py --data data/proofwiki.json --max 1000 --output outputs/run7/work_queue.json

    # Next 1000 theorems (Run 8)
    python scripts/create_work_queue.py --data data/proofwiki.json --max 1000 --offset 1000 --output outputs/run8/work_queue.json

    # Specific categories
    python scripts/create_work_queue.py --data data/proofwiki.json --max 500 --category "Number Theory" --category "Group Theory" --output outputs/run_nt_gt/work_queue.json
"""

import argparse
import json
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parents[1] / "src"))

from leanknowledge.proofwiki import load_proofwiki


def main():
    parser = argparse.ArgumentParser(description="Create a work queue for pool workers")
    parser.add_argument("--data", required=True, help="Path to proofwiki.json")
    parser.add_argument("--output", required=True, help="Output path for work_queue.json")
    parser.add_argument("--max", type=int, default=None, help="Max theorems to include")
    parser.add_argument("--offset", type=int, default=0, help="Skip first N theorems")
    parser.add_argument("--category", action="append", default=None,
                        help="Filter to category (repeatable)")
    args = parser.parse_args()

    # Load theorems
    load_max = (args.offset + args.max) if args.max else None
    items = load_proofwiki(
        Path(args.data),
        with_proof_only=True,
        categories=args.category,
        max_items=load_max,
    )

    # Apply offset
    if args.offset:
        items = items[args.offset:]
    if args.max:
        items = items[:args.max]

    print(f"Loaded {len(items)} theorems (offset={args.offset})")

    # Build queue
    queue_data = {
        "items": [
            {"index": args.offset + i, "id": item.id, "status": "pending", "worker": None}
            for i, item in enumerate(items)
        ],
    }

    # Write
    output_path = Path(args.output)
    output_path.parent.mkdir(parents=True, exist_ok=True)
    output_path.write_text(json.dumps(queue_data, indent=2, ensure_ascii=False))
    print(f"Queue written: {output_path} ({len(items)} items)")


if __name__ == "__main__":
    main()
