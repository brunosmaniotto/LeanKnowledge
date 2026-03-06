"""Agent 3: Triage — classifies extracted claims and populates the inbox.

Takes the output of Agent 2 (a list of ExtractedItems) and classifies each
as either a DEFINITION or a THEOREM, then places them into the inbox.

Classification rules:
  - DEFINITION: introduces a concept, structure, notation, or property
    that other items build on. Includes what textbooks call "axioms" —
    these are definitional properties of the structures being studied.
  - THEOREM: asserts something is true and requires proof. Includes
    propositions, lemmas, corollaries, and inline claims.

Definitions are formalized in Lean just like theorems (def, structure,
class, instance all need to typecheck). The category label travels with
the item through the backlog and pipeline.

NOTE: Dependency resolution (BLOCKED/READY status) is NOT handled here.
      This will be designed separately. See ARCHITECTURE.md for details.
"""

from datetime import datetime
from enum import Enum

from pydantic import BaseModel, Field

from ..schemas import ExtractionResult, ExtractedItem, StatementType


# ---------------------------------------------------------------------------
# Inbox schemas
# ---------------------------------------------------------------------------

class ItemCategory(str, Enum):
    DEFINITION = "definition"
    THEOREM = "theorem"


class InboxItem(BaseModel):
    """An extracted claim with its triage classification."""
    item: ExtractedItem
    category: ItemCategory
    added_at: datetime = Field(default_factory=datetime.now)


class Inbox(BaseModel):
    """Staging area: classified items ready to move to the backlog."""
    source: str
    items: list[InboxItem] = Field(default_factory=list)

    @property
    def definitions(self) -> list[InboxItem]:
        return [i for i in self.items if i.category == ItemCategory.DEFINITION]

    @property
    def theorems(self) -> list[InboxItem]:
        return [i for i in self.items if i.category == ItemCategory.THEOREM]


# ---------------------------------------------------------------------------
# Classification logic (deterministic, no LLM)
# ---------------------------------------------------------------------------

# Statement types that are always definitions
_DEFINITION_TYPES = {
    StatementType.DEFINITION,
    StatementType.AXIOM,           # axioms are treated as definitions
    StatementType.IMPLICIT_ASSUMPTION,
}

# Statement types that are always theorems
_THEOREM_TYPES = {
    StatementType.PROPOSITION,
    StatementType.THEOREM,
    StatementType.LEMMA,
    StatementType.COROLLARY,
    StatementType.CLAIM,
}

# Types that need role-based disambiguation
# EXAMPLE, REMARK, INVOKED_DEPENDENCY — classified by their role field


def classify(item: ExtractedItem) -> ItemCategory:
    """Classify an extracted item as DEFINITION or THEOREM.

    Deterministic: based on type and role fields, no LLM call.
    """
    if item.type in _DEFINITION_TYPES:
        return ItemCategory.DEFINITION

    if item.type in _THEOREM_TYPES:
        return ItemCategory.THEOREM

    # For ambiguous types (example, remark, invoked_dependency),
    # fall back to the role field
    if item.role.value == "definition":
        return ItemCategory.DEFINITION

    # Default: if it asserts something, it's a theorem
    return ItemCategory.THEOREM


# ---------------------------------------------------------------------------
# Main agent
# ---------------------------------------------------------------------------

class TriageAgent:
    """Agent 3: Classify extracted claims and build the inbox."""

    def triage(self, extraction: ExtractionResult) -> Inbox:
        """Classify all items from an extraction result.

        Args:
            extraction: output from Agent 2

        Returns:
            Inbox with classified items, preserving extraction order.
        """
        inbox = Inbox(source=extraction.source)

        for item in extraction.items:
            category = classify(item)
            inbox.items.append(InboxItem(item=item, category=category))

        n_def = len(inbox.definitions)
        n_thm = len(inbox.theorems)
        print(f"  [Agent 3] Triaged {len(inbox.items)} items: "
              f"{n_def} definitions, {n_thm} theorems")

        return inbox
