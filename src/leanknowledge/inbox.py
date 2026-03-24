"""Inbox — persistent store of ALL discovered items, before screening.

Every item enters the Inbox first (from extraction, axiom stubs, or
decomposition).  The pipeline's ``promote()`` method runs the Librarian
and moves survivors to the Queue (Backlog).  Duplicates stay in the
Inbox, marked as such.

This separation prevents the pipeline from re-proving items that
already exist in the Rosetta Stone or Mathlib.
"""

import json
from datetime import datetime
from enum import Enum
from pathlib import Path

from pydantic import BaseModel, Field

from .agents.triage import ItemCategory
from .schemas import ExtractedItem


# ---------------------------------------------------------------------------
# Enums
# ---------------------------------------------------------------------------

class InboxStatus(str, Enum):
    NEW = "new"              # discovered, not yet screened
    PROMOTED = "promoted"    # passed Librarian, moved to Queue
    DUPLICATE = "duplicate"  # exact match found, skipped


class InboxOrigin(str, Enum):
    EXTRACTION = "extraction"       # from OCR/PDF
    AXIOM_STUB = "axiom_stub"       # from axiom stubs in compiled Lean
    DECOMPOSITION = "decomposition" # from Tier 3 sub-lemma creation


# ---------------------------------------------------------------------------
# Entry model
# ---------------------------------------------------------------------------

class InboxEntry(BaseModel):
    """A single item in the inbox."""
    item: ExtractedItem
    category: ItemCategory
    origin: InboxOrigin
    status: InboxStatus = InboxStatus.NEW

    # Screening metadata (populated by promote)
    screening_verdict: str | None = None   # "exact", "partial", "none"
    matched_name: str | None = None
    similarity: float | None = None

    # Axiom-stub metadata (preserved for backlog entry creation)
    created_during: str | None = None      # parent item_id

    # Timestamps
    added_at: datetime = Field(default_factory=datetime.now)
    promoted_at: datetime | None = None


# ---------------------------------------------------------------------------
# Inbox store
# ---------------------------------------------------------------------------

class Inbox:
    """Persistent staging area for discovered items."""

    def __init__(self):
        self.entries: dict[str, InboxEntry] = {}

    def add(
        self,
        item: ExtractedItem,
        category: ItemCategory,
        origin: InboxOrigin,
        created_during: str | None = None,
    ) -> InboxEntry:
        """Add an item to the inbox. Skips if already present (by id)."""
        if item.id in self.entries:
            return self.entries[item.id]

        entry = InboxEntry(
            item=item,
            category=category,
            origin=origin,
            created_during=created_during,
        )
        self.entries[item.id] = entry
        return entry

    # --- Filters ---

    def new_entries(self) -> list[InboxEntry]:
        """Items not yet screened."""
        return [e for e in self.entries.values() if e.status == InboxStatus.NEW]

    def promoted(self) -> list[InboxEntry]:
        """Items that passed screening and were moved to Queue."""
        return [e for e in self.entries.values() if e.status == InboxStatus.PROMOTED]

    def duplicates(self) -> list[InboxEntry]:
        """Items that matched existing entries (skipped)."""
        return [e for e in self.entries.values() if e.status == InboxStatus.DUPLICATE]

    # --- Stats ---

    @property
    def stats(self) -> dict[str, int]:
        counts: dict[str, int] = {}
        for entry in self.entries.values():
            counts[entry.status.value] = counts.get(entry.status.value, 0) + 1
        return counts

    # --- Persistence ---

    def save(self, path: Path) -> None:
        """Save inbox state to JSON."""
        data = {
            item_id: entry.model_dump(mode="json")
            for item_id, entry in self.entries.items()
        }
        path.parent.mkdir(parents=True, exist_ok=True)
        path.write_text(json.dumps(data, indent=2), encoding="utf-8")

    def load(self, path: Path) -> None:
        """Load inbox state from JSON. Merges with existing entries."""
        if not path.exists():
            return
        data = json.loads(path.read_text(encoding="utf-8"))
        for item_id, entry_data in data.items():
            if item_id not in self.entries:
                self.entries[item_id] = InboxEntry.model_validate(entry_data)
