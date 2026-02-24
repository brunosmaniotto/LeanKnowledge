#!/usr/bin/env python3
"""Seed the Strategy KB from Rosetta Stone pairs.

Parses all Rosetta Stone pair files and bulk-inserts StrategyEntry objects
into the KB. Since these are verified Mathlib declarations, they all get
iterations_to_compile=1, difficulty based on complexity, and no errors.

Usage:
    python scripts/seed_strategy_kb.py
    python scripts/seed_strategy_kb.py --pairs-dir rosetta_stone/pairs --output strategy_kb.json
    python scripts/seed_strategy_kb.py --dry-run  # count pairs without writing
"""

import argparse
import json
import sys
from collections import Counter
from pathlib import Path

PROJECT_ROOT = Path(__file__).resolve().parent.parent
sys.path.insert(0, str(PROJECT_ROOT / "src"))

from leanknowledge.strategy_kb import StrategyKB, StrategyEntry

COMPLEXITY_TO_DIFFICULTY = {
    "trivial": "easy",
    "simple": "easy",
    "moderate": "medium",
    "complex": "hard",
}


def parse_pair(pair: dict, module: str) -> StrategyEntry | None:
    """Convert a single Rosetta Stone pair to a StrategyEntry."""
    nl_proof = pair.get("nl_proof", {})
    metadata = pair.get("metadata", {})

    strategy = nl_proof.get("strategy", "")
    if not strategy:
        return None

    complexity = metadata.get("complexity", "moderate")
    difficulty = COMPLEXITY_TO_DIFFICULTY.get(complexity, "medium")

    return StrategyEntry(
        theorem_id=pair.get("id", pair.get("mathlib_name", "unknown")),
        domain=metadata.get("domain", "unknown"),
        mathematical_objects=metadata.get("tags", []),
        proof_strategies=[strategy],
        lean_tactics_used=metadata.get("lean_tactics_used", []),
        lean_tactics_failed=[],
        difficulty=difficulty,
        iterations_to_compile=1,  # Mathlib code compiles
        proof_revisions=0,
        error_types_encountered=[],
        dependencies_used=nl_proof.get("dependencies", []),
        source=f"Mathlib:{module}" if module else "Mathlib",
    )


def load_pairs_from_file(path: Path) -> tuple[list[StrategyEntry], str]:
    """Load a Rosetta Stone pair file and return StrategyEntries + module name."""
    try:
        data = json.loads(path.read_text(encoding="utf-8"))
    except (json.JSONDecodeError, UnicodeDecodeError):
        return [], ""

    # File-level format: {"module": "...", "pairs": [...]}
    if isinstance(data, dict) and "pairs" in data:
        module = data.get("module", "")
        pairs = data["pairs"]
    # Legacy format: bare list of pairs
    elif isinstance(data, list):
        module = ""
        pairs = data
    else:
        return [], ""

    entries = []
    for pair in pairs:
        if not isinstance(pair, dict):
            continue
        entry = parse_pair(pair, module)
        if entry is not None:
            entries.append(entry)

    return entries, module


def main():
    parser = argparse.ArgumentParser(description="Seed Strategy KB from Rosetta Stone")
    parser.add_argument("--pairs-dir", default=str(PROJECT_ROOT / "rosetta_stone" / "pairs"),
                        help="Directory containing Rosetta Stone pair JSON files")
    parser.add_argument("--output", default=str(PROJECT_ROOT / "strategy_kb.json"),
                        help="Output path for strategy_kb.json")
    parser.add_argument("--dry-run", action="store_true",
                        help="Count pairs without writing to KB")
    parser.add_argument("--skip-existing", action="store_true",
                        help="Don't add entries already in the KB (by theorem_id)")
    args = parser.parse_args()

    pairs_dir = Path(args.pairs_dir)
    if not pairs_dir.exists():
        print(f"Error: pairs directory not found: {pairs_dir}")
        sys.exit(1)

    # Find all pair files (exclude index.json)
    pair_files = sorted(
        p for p in pairs_dir.glob("*.json")
        if p.name != "index.json"
    )
    print(f"Found {len(pair_files)} pair files in {pairs_dir}")

    all_entries: list[StrategyEntry] = []
    domain_counts: Counter = Counter()
    strategy_counts: Counter = Counter()
    difficulty_counts: Counter = Counter()

    for path in pair_files:
        entries, module = load_pairs_from_file(path)
        all_entries.extend(entries)

        for e in entries:
            domain_counts[e.domain] += 1
            for s in e.proof_strategies:
                strategy_counts[s] += 1
            difficulty_counts[e.difficulty] += 1

    print(f"\nParsed {len(all_entries)} entries from {len(pair_files)} files")
    print(f"\nDomain distribution:")
    for domain, count in domain_counts.most_common():
        print(f"  {domain}: {count}")
    print(f"\nStrategy distribution:")
    for strategy, count in strategy_counts.most_common(10):
        print(f"  {strategy}: {count}")
    print(f"\nDifficulty distribution:")
    for diff, count in difficulty_counts.most_common():
        print(f"  {diff}: {count}")

    if args.dry_run:
        print(f"\n[dry-run] Would write {len(all_entries)} entries to {args.output}")
        return

    # Load existing KB (if any) and optionally skip duplicates
    kb = StrategyKB(path=Path(args.output))
    if args.skip_existing and kb.entries:
        existing_ids = {e.theorem_id for e in kb.entries}
        new_entries = [e for e in all_entries if e.theorem_id not in existing_ids]
        skipped = len(all_entries) - len(new_entries)
        print(f"\nSkipping {skipped} entries already in KB")
        all_entries = new_entries

    kb.bulk_add(all_entries)
    print(f"\nWrote {len(kb.entries)} total entries to {args.output}")


if __name__ == "__main__":
    main()
