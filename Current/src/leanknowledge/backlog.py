"""Backlog — the work queue for items that need formalization.

Items enter the backlog from two paths:
  1. Agent 4 (Librarian) sends non-duplicate inbox items here
  2. The Proving Agent axiomatizes dependencies it encounters mid-proof

Dependency resolution:
  When an item is added, its dependencies (item.dependencies) are checked
  against the backlog. If all are resolved → READY. If not → BLOCKED.
  When an item is completed or axiomatized, blocked items are re-checked.
  Dependencies not in the backlog are treated as external (resolved).
"""

from datetime import datetime
from enum import Enum

from pydantic import BaseModel, Field

from .schemas import ExtractedItem
from .agents.triage import ItemCategory


# ---------------------------------------------------------------------------
# Backlog schemas
# ---------------------------------------------------------------------------

class BacklogStatus(str, Enum):
    PENDING = "pending"              # legacy: entered backlog, not yet resolved
    READY = "ready"                  # all dependencies resolved, can formalize
    BLOCKED = "blocked"              # waiting on unresolved backlog dependencies
    IN_PROGRESS = "in_progress"      # currently being proved
    COMPLETED = "completed"          # successfully formalized in Lean
    FAILED = "failed"                # formalization attempted, did not succeed
    AXIOMATIZED = "axiomatized"      # accepted as axiom (dependency placeholder)


# Statuses that count as "resolved" for dependency checking
_RESOLVED = frozenset({BacklogStatus.COMPLETED, BacklogStatus.AXIOMATIZED})

# Statuses eligible for dependency re-resolution
_RESOLVABLE = frozenset({BacklogStatus.PENDING, BacklogStatus.READY, BacklogStatus.BLOCKED})


class DependencyType(str, Enum):
    """How the dependency was introduced."""
    CITATION = "citation"
    CLAIMED_KNOWN = "claimed_known"
    PREVIOUS_CLAIM = "previous_claim"
    IMPLICIT = "implicit"


class DependencyInfo(BaseModel):
    """Metadata for axiomatized dependencies."""
    dependency_type: DependencyType
    has_citation: bool = False
    citation_source: str | None = None
    lean_axiom_name: str | None = None
    created_during: str | None = None


class BacklogEntry(BaseModel):
    """A single item in the backlog."""
    item: ExtractedItem
    category: ItemCategory
    status: BacklogStatus = BacklogStatus.PENDING
    dependency_info: DependencyInfo | None = None
    lean_file: str | None = None
    failure_reason: str | None = None
    attempts: int = 0
    added_at: datetime = Field(default_factory=datetime.now)
    completed_at: datetime | None = None


# ---------------------------------------------------------------------------
# Backlog store
# ---------------------------------------------------------------------------

class Backlog:
    """In-memory backlog with automatic dependency resolution."""

    def __init__(self):
        self.entries: dict[str, BacklogEntry] = {}

    # --- Add items ---

    def add(self, entry: BacklogEntry) -> None:
        """Add an item to the backlog. Auto-resolves dependencies."""
        if entry.item.id in self.entries:
            return
        self.entries[entry.item.id] = entry
        self._resolve(entry.item.id)

    def add_axiomatized(
        self,
        item: ExtractedItem,
        category: ItemCategory,
        dependency_type: DependencyType,
        has_citation: bool = False,
        citation_source: str | None = None,
        lean_axiom_name: str | None = None,
        created_during: str | None = None,
    ) -> BacklogEntry:
        """Add an axiomatized dependency. Propagates to unblock dependents."""
        if item.id in self.entries:
            return self.entries[item.id]

        entry = BacklogEntry(
            item=item,
            category=category,
            status=BacklogStatus.AXIOMATIZED,
            dependency_info=DependencyInfo(
                dependency_type=dependency_type,
                has_citation=has_citation,
                citation_source=citation_source,
                lean_axiom_name=lean_axiom_name,
                created_during=created_during,
            ),
        )
        self.entries[item.id] = entry
        self._propagate(item.id)
        return entry

    # --- Query ---

    def get(self, item_id: str) -> BacklogEntry | None:
        return self.entries.get(item_id)

    def ready(self) -> list[BacklogEntry]:
        return [e for e in self.entries.values() if e.status == BacklogStatus.READY]

    def blocked(self) -> list[BacklogEntry]:
        return [e for e in self.entries.values() if e.status == BacklogStatus.BLOCKED]

    def pending(self) -> list[BacklogEntry]:
        return [e for e in self.entries.values() if e.status == BacklogStatus.PENDING]

    def axiomatized(self) -> list[BacklogEntry]:
        return [e for e in self.entries.values() if e.status == BacklogStatus.AXIOMATIZED]

    def completed(self) -> list[BacklogEntry]:
        return [e for e in self.entries.values() if e.status == BacklogStatus.COMPLETED]

    def unresolved_deps(self, item_id: str) -> list[str]:
        """Return dependency IDs that are not yet resolved."""
        entry = self.entries[item_id]
        return [d for d in entry.item.dependencies if not self._is_resolved(d)]

    # --- Status transitions ---

    def mark_in_progress(self, item_id: str) -> None:
        entry = self.entries[item_id]
        entry.status = BacklogStatus.IN_PROGRESS
        entry.attempts += 1

    def mark_completed(self, item_id: str, lean_file: str) -> list[str]:
        """Mark item as completed. Returns IDs of newly unblocked items."""
        entry = self.entries[item_id]
        entry.status = BacklogStatus.COMPLETED
        entry.lean_file = lean_file
        entry.completed_at = datetime.now()
        return self._propagate(item_id)

    def mark_failed(self, item_id: str, reason: str) -> None:
        entry = self.entries[item_id]
        entry.status = BacklogStatus.FAILED
        entry.failure_reason = reason

    # --- Dependency resolution ---

    def _is_resolved(self, dep_id: str) -> bool:
        """Check if a dependency is resolved.

        External dependencies (not in backlog) are treated as resolved —
        the prover will axiomatize them if needed at proof time.
        """
        entry = self.entries.get(dep_id)
        if entry is None:
            return True
        return entry.status in _RESOLVED

    def _resolve(self, item_id: str) -> None:
        """Set an item's status to READY or BLOCKED based on its dependencies."""
        entry = self.entries[item_id]
        if entry.status not in _RESOLVABLE:
            return

        deps = entry.item.dependencies
        if not deps or all(self._is_resolved(d) for d in deps):
            entry.status = BacklogStatus.READY
        else:
            entry.status = BacklogStatus.BLOCKED

    def _propagate(self, resolved_id: str) -> list[str]:
        """Re-resolve all BLOCKED items after a dependency is resolved.

        Returns IDs of items that became READY.
        """
        unblocked = []
        for item_id, entry in self.entries.items():
            if entry.status != BacklogStatus.BLOCKED:
                continue
            if resolved_id in entry.item.dependencies:
                self._resolve(item_id)
                if entry.status == BacklogStatus.READY:
                    unblocked.append(item_id)
        return unblocked

    def resolve_all(self) -> None:
        """Resolve all PENDING items. Call after loading an old backlog."""
        for item_id in list(self.entries):
            entry = self.entries[item_id]
            if entry.status == BacklogStatus.PENDING:
                self._resolve(item_id)

    # --- Stats ---

    @property
    def stats(self) -> dict[str, int]:
        counts: dict[str, int] = {}
        for entry in self.entries.values():
            counts[entry.status.value] = counts.get(entry.status.value, 0) + 1
        return counts
