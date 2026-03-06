#!/usr/bin/env python3
"""Triage stuck backlog items — reset IN_PROGRESS back to PENDING so dependency
refresh can move them to READY or BLOCKED."""

import argparse
import sys
from pathlib import Path

# Add project root to path
sys.path.insert(0, str(Path(__file__).resolve().parents[1] / "src"))

from leanknowledge.backlog import Backlog
from leanknowledge.schemas import BacklogStatus


def main():
    parser = argparse.ArgumentParser(description="Reset stuck IN_PROGRESS backlog items")
    parser.add_argument("--backlog", default="backlog.json", help="Path to backlog.json")
    parser.add_argument("--dry-run", action="store_true", help="Show what would be reset without changing anything")
    parser.add_argument("--reset-failed", action="store_true", help="Also reset FAILED items back to PENDING")
    args = parser.parse_args()

    backlog = Backlog(path=Path(args.backlog))

    # Find stuck items
    stuck = [e for e in backlog.entries.values() if e.status == BacklogStatus.IN_PROGRESS]
    failed = [e for e in backlog.entries.values() if e.status == BacklogStatus.FAILED] if args.reset_failed else []

    print(f"Current backlog state:")
    print(backlog.summary())
    print()

    if not stuck and not failed:
        print("No stuck items found.")
        return

    print(f"Found {len(stuck)} IN_PROGRESS items to reset:")
    for entry in stuck:
        print(f"  {entry.item.id} (attempts: {entry.attempts})")

    if failed:
        print(f"\nFound {len(failed)} FAILED items to reset:")
        for entry in failed:
            print(f"  {entry.item.id}: {entry.failure_reason or 'no reason'}")

    if args.dry_run:
        print("\n[DRY RUN] No changes made.")
        return

    # Reset stuck items to PENDING (refresh will move them to READY or BLOCKED)
    for entry in stuck:
        entry.status = BacklogStatus.PENDING

    for entry in failed:
        entry.status = BacklogStatus.PENDING
        entry.failure_reason = None

    # Refresh statuses (PENDING → READY or BLOCKED based on dependencies)
    backlog._refresh_statuses()
    backlog._save()

    print(f"\nReset {len(stuck)} IN_PROGRESS + {len(failed)} FAILED items.")
    print("\nNew backlog state:")
    print(backlog.summary())


if __name__ == "__main__":
    main()
