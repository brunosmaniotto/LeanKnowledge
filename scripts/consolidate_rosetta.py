#!/usr/bin/env python3
"""Consolidate per-chapter rosetta_stone.jsonl files into one unified corpus.

The pipeline writes rosetta entries per-chapter (outputs/mwg_ch{N}/rosetta_stone.jsonl),
but the MathlibIndex and Librarian search a single file. This script merges them.

Deduplication: when the same item ID appears in multiple chapters or multiple entries
within a chapter (from retries), the LATEST entry wins (by timestamp, then by position
in file).

Usage:
    python scripts/consolidate_rosetta.py [--base-dir DIR] [--output PATH]
    python scripts/consolidate_rosetta.py  # defaults: outputs/ → outputs/rosetta_consolidated.jsonl

Can also be imported:
    from scripts.consolidate_rosetta import consolidate_rosetta_stones
    stats = consolidate_rosetta_stones(base_dir, output_path)
"""

import argparse
import json
import sys
from pathlib import Path


def consolidate_rosetta_stones(
    base_dir: Path,
    output_path: Path,
) -> dict:
    """Merge all per-chapter rosetta_stone.jsonl into one file.

    Args:
        base_dir: Directory containing mwg_ch{N}/ and mwg_appendix/ subdirs.
        output_path: Where to write the consolidated JSONL.

    Returns:
        Stats dict: {chapters_found, total_lines, unique_ids, duplicates_skipped}
    """
    base_dir = Path(base_dir)
    output_path = Path(output_path)

    # Collect all rosetta files
    rosetta_files: list[tuple[Path, str]] = []
    for d in sorted(base_dir.iterdir()):
        if not d.is_dir():
            continue
        if not (d.name.startswith("mwg_ch") or d.name == "mwg_appendix"):
            continue
        rf = d / "rosetta_stone.jsonl"
        if rf.exists():
            rosetta_files.append((rf, d.name))

    # Read all entries, track by item ID (latest wins)
    entries: dict[str, dict] = {}  # id → entry (latest)
    total_lines = 0

    for rf, chapter_name in rosetta_files:
        with open(rf, encoding="utf-8") as f:
            for line in f:
                line = line.strip()
                if not line:
                    continue
                total_lines += 1
                try:
                    entry = json.loads(line)
                except json.JSONDecodeError:
                    continue
                item_id = entry.get("id", "")
                if not item_id:
                    continue
                # Tag with source chapter for traceability
                entry["_source_chapter"] = chapter_name
                # Latest entry wins (by timestamp if available, else last-seen)
                existing = entries.get(item_id)
                if existing is None:
                    entries[item_id] = entry
                else:
                    new_ts = entry.get("timestamp", "")
                    old_ts = existing.get("timestamp", "")
                    if new_ts >= old_ts:
                        entries[item_id] = entry

    # Write consolidated file
    output_path.parent.mkdir(parents=True, exist_ok=True)
    with open(output_path, "w", encoding="utf-8") as f:
        for entry in sorted(entries.values(), key=lambda e: e.get("id", "")):
            f.write(json.dumps(entry, ensure_ascii=False) + "\n")

    stats = {
        "chapters_found": len(rosetta_files),
        "total_lines": total_lines,
        "unique_ids": len(entries),
        "duplicates_skipped": total_lines - len(entries),
        "output_path": str(output_path),
    }
    return stats


def main():
    parser = argparse.ArgumentParser(description="Consolidate rosetta stones")
    parser.add_argument("--base-dir", type=str, default=None,
                        help="Base outputs directory (default: outputs)")
    parser.add_argument("--output", type=str, default=None,
                        help="Output path (default: base_dir/rosetta_consolidated.jsonl)")
    args = parser.parse_args()

    if args.base_dir:
        base = Path(args.base_dir)
    else:
        base = Path(__file__).resolve().parent.parent / "outputs"

    output = Path(args.output) if args.output else base / "rosetta_consolidated.jsonl"

    print(f"Scanning {base} ...", file=sys.stderr)
    stats = consolidate_rosetta_stones(base, output)

    print(f"Chapters found:     {stats['chapters_found']}")
    print(f"Total JSONL lines:  {stats['total_lines']}")
    print(f"Unique item IDs:    {stats['unique_ids']}")
    print(f"Duplicates skipped: {stats['duplicates_skipped']}")
    print(f"Output:             {stats['output_path']}")


if __name__ == "__main__":
    main()
