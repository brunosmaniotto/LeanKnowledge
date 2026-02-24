"""Backlog — persistent work queue for the formalization pipeline.

The backlog tracks every extracted mathematical item and its formalization status.
It resolves dependencies to determine which items are ready to be formalized next.
Both bottom-up (textbook extraction) and top-down (paper analysis) feed into it.
"""

import json
from datetime import datetime
from pathlib import Path

from .schemas import (
    ExtractedItem,
    ExtractionResult,
    BacklogEntry,
    BacklogStatus,
    Domain,
    StatementType,
    ClaimRole,
)

# Types that don't need proving — they're resolved by being in the backlog
NON_PROVABLE = {"definition", "axiom", "example", "remark"}

DEFAULT_PATH = Path(__file__).resolve().parents[2] / "backlog.json"


class Backlog:
    def __init__(self, path: Path = DEFAULT_PATH):
        self.path = path
        self.entries: dict[str, BacklogEntry] = {}

        # Check for SQLite database
        self._db_path = path.parent / "leanknowledge.db"
        self._use_sqlite = self._db_path.exists()

        if self._use_sqlite:
            from .storage import BacklogStore
            self._store = BacklogStore(self._db_path)
            self.entries = self._store.load_all()
        elif self.path.exists():
            self._load()

    # --- Adding items ---

    def add_extraction(self, result: ExtractionResult, domain: Domain) -> list[str]:
        """Add all items from an extraction result. Returns list of new IDs added."""
        new_ids = []
        for item in result.items:
            if item.id not in self.entries:
                status = BacklogStatus.SKIPPED if item.type.value in NON_PROVABLE else BacklogStatus.PENDING
                self.entries[item.id] = BacklogEntry(
                    item=item,
                    source=result.source,
                    domain=domain,
                    status=status,
                )
                new_ids.append(item.id)
        self._refresh_statuses()
        self._save()
        return new_ids

    def add_item(self, item: ExtractedItem, source: str, domain: Domain) -> bool:
        """Add a single item. Returns True if it was new."""
        if item.id in self.entries:
            return False
        status = BacklogStatus.SKIPPED if item.type.value in NON_PROVABLE else BacklogStatus.PENDING
        self.entries[item.id] = BacklogEntry(
            item=item, source=source, domain=domain, status=status,
        )
        self._refresh_statuses()
        self._save()
        return True

    # --- Querying ---

    def get_ready(self) -> list[BacklogEntry]:
        """Return entries whose dependencies are all resolved, ordered by appearance."""
        return [e for e in self.entries.values() if e.status == BacklogStatus.READY]

    def get_blocked(self) -> list[tuple[BacklogEntry, list[str]]]:
        """Return blocked entries with their unresolved dependency IDs."""
        result = []
        for entry in self.entries.values():
            if entry.status == BacklogStatus.BLOCKED:
                unresolved = self._unresolved_deps(entry)
                result.append((entry, unresolved))
        return result

    def get_feedable(self, limit: int = 10) -> list[BacklogEntry]:
        """Return blocked items that the Feeder agent should try to find sources for.

        Selection criteria:
        - Status is BLOCKED (waiting on unresolved dependencies)
        - Item role is 'invoked_dependency' or 'implicit_assumption' (needs external source)
        - OR: item has category 'referenced' or 'omitted_proof' (references an external work)
        - NOT already FAILED more than 2 times (don't re-feed repeated failures)

        Prioritization (highest first):
        - Items with the most downstream dependents (highest priority_score)
        - Referenced items before unreferenced (more likely to succeed)
        - Items with fewer prior attempts

        Returns:
            List of BacklogEntry objects, sorted by priority, up to limit.
        """
        candidates = []
        for entry in self.entries.values():
            if entry.status != BacklogStatus.BLOCKED:
                continue
            
            if entry.attempts > 2:
                continue

            needs_external = entry.item.role in (ClaimRole.INVOKED_DEPENDENCY, ClaimRole.IMPLICIT_ASSUMPTION)
            has_ref = entry.category in ("referenced", "omitted_proof")

            if needs_external or has_ref:
                candidates.append(entry)

        # Sort
        # Category rank: referenced=0, omitted_proof=1, unreferenced=2
        cat_rank = {"referenced": 0, "omitted_proof": 1, "unreferenced": 2}
        
        candidates.sort(key=lambda e: (
            -e.priority_score,
            cat_rank.get(e.category, 2),
            e.attempts
        ))

        return candidates[:limit]

    def get_axiomatized(self) -> list[BacklogEntry]:
        """Return axiomatized entries (failed theorems accepted as axioms).
        These are candidates for the Resolver — true mathematical axioms
        (type='axiom', status='skipped') are never returned here."""
        return [e for e in self.entries.values()
                if e.status == BacklogStatus.AXIOMATIZED]

    def get_entry(self, item_id: str) -> BacklogEntry | None:
        return self.entries.get(item_id)

    def next(self) -> BacklogEntry | None:
        """Return the next item to formalize (first ready item)."""
        ready = self.get_ready()
        return ready[0] if ready else None

    # --- Status updates ---

    def mark_in_progress(self, item_id: str):
        entry = self.entries[item_id]
        entry.status = BacklogStatus.IN_PROGRESS
        entry.attempts += 1
        self._save_entry(item_id)

    def mark_completed(self, item_id: str, lean_file: str | None = None):
        entry = self.entries[item_id]
        entry.status = BacklogStatus.COMPLETED
        entry.lean_file = lean_file
        entry.completed_at = datetime.now()
        self._refresh_statuses()  # completing an item may unblock others
        self._save()  # full save — refresh may change many entries

    def mark_failed(self, item_id: str, reason: str = ""):
        entry = self.entries[item_id]
        entry.status = BacklogStatus.FAILED
        entry.failure_reason = reason
        self._save_entry(item_id)

    def restore_axiomatized(self, item_id: str):
        """Restore a failed resolution attempt back to AXIOMATIZED status."""
        entry = self.entries[item_id]
        entry.status = BacklogStatus.AXIOMATIZED
        self._save_entry(item_id)

    def mark_axiomatized(self, item_id: str, lean_file: str = "LeanProject/Axioms.lean"):
        """Mark a failed item as axiomatized, unblocking its dependents."""
        entry = self.entries[item_id]
        entry.status = BacklogStatus.AXIOMATIZED
        entry.lean_file = lean_file
        self._refresh_statuses()  # unblock dependents
        self._save()

    # --- Dependency resolution ---

    def _is_resolved(self, item_id: str) -> bool:
        """An item is resolved if it's completed, skipped, or not in the backlog
        (assumed external / in Mathlib)."""
        if item_id not in self.entries:
            # External dependency — assume available (Mathlib, axioms)
            # TODO: check against Mathlib index
            return True
        return self.entries[item_id].status in (
            BacklogStatus.COMPLETED, BacklogStatus.SKIPPED, BacklogStatus.AXIOMATIZED
        )

    def _unresolved_deps(self, entry: BacklogEntry) -> list[str]:
        """Return list of dependency IDs that are not yet resolved."""
        return [dep for dep in entry.item.dependencies if not self._is_resolved(dep)]

    def _refresh_statuses(self):
        """Update PENDING/BLOCKED/READY statuses and calculate priority scores."""
        # 1. Calculate Priority Scores (count of items that depend on this one)
        # Reset all scores first
        for entry in self.entries.values():
            entry.priority_score = 0
            
        for entry in self.entries.values():
            for dep in entry.item.dependencies:
                if dep in self.entries:
                    self.entries[dep].priority_score += 1

        # 2. Refresh statuses based on dependency state
        for entry in self.entries.values():
            if entry.status in (BacklogStatus.COMPLETED, BacklogStatus.SKIPPED,
                                BacklogStatus.IN_PROGRESS, BacklogStatus.FAILED,
                                BacklogStatus.AXIOMATIZED):
                continue

            unresolved = self._unresolved_deps(entry)
            if unresolved:
                entry.status = BacklogStatus.BLOCKED
            else:
                entry.status = BacklogStatus.READY

    # --- Reporting ---

    def summary(self) -> str:
        """Return a human-readable summary of backlog state."""
        counts = {}
        for entry in self.entries.values():
            counts[entry.status.value] = counts.get(entry.status.value, 0) + 1

        total = len(self.entries)
        lines = [f"Backlog: {total} items"]
        for status in BacklogStatus:
            count = counts.get(status.value, 0)
            if count:
                lines.append(f"  {status.value}: {count}")

        blocked = self.get_blocked()
        if blocked:
            lines.append(f"\nBlocked items ({len(blocked)}):")
            for entry, unresolved in blocked:
                lines.append(f"  {entry.item.id} — waiting on: {', '.join(unresolved)}")

        ready = self.get_ready()
        if ready:
            # Sort by priority score (descending)
            ready.sort(key=lambda e: e.priority_score, reverse=True)
            lines.append(f"\nReady to formalize ({len(ready)}):")
            for entry in ready:
                priority = f" [priority: {entry.priority_score}]" if entry.priority_score else ""
                lines.append(f"  {entry.item.id} ({entry.item.type.value}){priority}")

        return "\n".join(lines)

    # --- Persistence ---

    def _save(self):
        """Full save — JSON always, SQLite bulk if active."""
        data = {item_id: entry.model_dump(mode="json") for item_id, entry in self.entries.items()}
        self.path.write_text(json.dumps(data, indent=2, default=str))

        if self._use_sqlite:
            self._store.save_all(self.entries)

    def _save_entry(self, item_id: str):
        """Incremental save — JSON full rewrite, SQLite single upsert."""
        data = {iid: entry.model_dump(mode="json") for iid, entry in self.entries.items()}
        self.path.write_text(json.dumps(data, indent=2, default=str))

        if self._use_sqlite:
            self._store.upsert(item_id, self.entries[item_id])

    def _load(self):
        raw = json.loads(self.path.read_text())
        self.entries = {item_id: BacklogEntry.model_validate(entry) for item_id, entry in raw.items()}
