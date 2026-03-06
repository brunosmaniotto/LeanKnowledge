"""Agent 4: Librarian — deduplication gate between inbox and backlog.

Checks each inbox item against:
  1. The knowledge tree (items we've already formalized)
  2. Mathlib (via Rosetta Stone corpus)

Outcomes:
  - EXACT_MATCH:   item already exists. Skip, record the link.
  - PARTIAL_MATCH: related item exists but not identical. Goes to backlog.
  - NO_MATCH:      nothing found. Goes to backlog.

Both definitions and theorems are checked.

Current implementation: name matching + text similarity.
Production target: embedding-based semantic search over Rosetta Stone.
"""

from dataclasses import dataclass, field
from difflib import SequenceMatcher
from enum import Enum

from .triage import Inbox, InboxItem, ItemCategory


# ---------------------------------------------------------------------------
# Search result types
# ---------------------------------------------------------------------------

class MatchType(str, Enum):
    EXACT = "exact"
    PARTIAL = "partial"
    NONE = "none"


@dataclass
class LibrarianVerdict:
    """Result of checking one item against the library."""
    item: InboxItem
    match_type: MatchType
    matched_name: str | None = None       # name in Mathlib or knowledge tree
    matched_source: str | None = None     # "mathlib" or "knowledge_tree"
    similarity: float = 0.0
    notes: str | None = None


@dataclass
class LibrarianResult:
    """Full result of checking an inbox against the library."""
    exact_matches: list[LibrarianVerdict] = field(default_factory=list)
    partial_matches: list[LibrarianVerdict] = field(default_factory=list)
    no_matches: list[LibrarianVerdict] = field(default_factory=list)

    @property
    def to_skip(self) -> list[LibrarianVerdict]:
        return self.exact_matches

    @property
    def to_backlog(self) -> list[LibrarianVerdict]:
        return self.partial_matches + self.no_matches


# ---------------------------------------------------------------------------
# Library interface (swappable backends)
# ---------------------------------------------------------------------------

class Library:
    """Interface for searching existing formalized content.

    Subclass this to plug in different search backends:
      - InMemoryLibrary: for testing, uses dicts
      - RosettaStoneLibrary: embedding search over Rosetta Stone (production)
      - MathLibSearch: Loogle API + BM25 (production)
    """

    def search(self, statement: str, name: str = "") -> list[dict]:
        """Search for matching items.

        Args:
            statement: the mathematical statement to search for
            name: optional item name/ID for exact matching

        Returns:
            list of dicts with keys: name, source, statement, similarity
            Sorted by similarity descending.
        """
        raise NotImplementedError


class InMemoryLibrary(Library):
    """Simple in-memory library for testing and bootstrapping."""

    def __init__(self):
        self.entries: list[dict] = []

    def add(self, name: str, statement: str, source: str = "knowledge_tree"):
        self.entries.append({
            "name": name, "statement": statement, "source": source,
        })

    def search(self, statement: str, name: str = "") -> list[dict]:
        results = []
        norm_stmt = _normalize(statement)
        norm_name = _normalize(name)

        for entry in self.entries:
            # Name similarity
            name_sim = SequenceMatcher(
                None, norm_name, _normalize(entry["name"])
            ).ratio() if norm_name else 0.0

            # Statement similarity
            stmt_sim = SequenceMatcher(
                None, norm_stmt, _normalize(entry["statement"])
            ).ratio()

            # Take the higher of the two
            similarity = max(name_sim, stmt_sim)

            results.append({
                "name": entry["name"],
                "source": entry["source"],
                "statement": entry["statement"],
                "similarity": similarity,
            })

        results.sort(key=lambda r: r["similarity"], reverse=True)
        return results


def _normalize(s: str) -> str:
    return " ".join(s.lower().split())


# ---------------------------------------------------------------------------
# Thresholds
# ---------------------------------------------------------------------------

EXACT_THRESHOLD = 0.90    # above this → exact match (skip)
PARTIAL_THRESHOLD = 0.50  # above this → partial match (backlog, flagged)


# ---------------------------------------------------------------------------
# Main agent
# ---------------------------------------------------------------------------

class LibrarianAgent:
    """Agent 4: Check inbox items against existing formalized content."""

    def __init__(self, library: Library):
        self.library = library

    def check(self, inbox: Inbox) -> LibrarianResult:
        """Check every inbox item against the library.

        Args:
            inbox: classified items from Agent 3

        Returns:
            LibrarianResult with items sorted into exact/partial/no match.
        """
        result = LibrarianResult()

        for inbox_item in inbox.items:
            verdict = self._check_one(inbox_item)

            if verdict.match_type == MatchType.EXACT:
                result.exact_matches.append(verdict)
            elif verdict.match_type == MatchType.PARTIAL:
                result.partial_matches.append(verdict)
            else:
                result.no_matches.append(verdict)

        n_exact = len(result.exact_matches)
        n_partial = len(result.partial_matches)
        n_none = len(result.no_matches)
        print(f"  [Agent 4] Librarian: {n_exact} exact matches (skip), "
              f"{n_partial} partial, {n_none} new → "
              f"{n_partial + n_none} to backlog")

        return result

    def _check_one(self, inbox_item: InboxItem) -> LibrarianVerdict:
        """Check a single item against the library."""
        item = inbox_item.item
        hits = self.library.search(statement=item.statement, name=item.id)

        if not hits:
            return LibrarianVerdict(
                item=inbox_item, match_type=MatchType.NONE,
            )

        best = hits[0]

        if best["similarity"] >= EXACT_THRESHOLD:
            return LibrarianVerdict(
                item=inbox_item,
                match_type=MatchType.EXACT,
                matched_name=best["name"],
                matched_source=best["source"],
                similarity=best["similarity"],
                notes=f"Exact match: {best['name']} in {best['source']}",
            )

        if best["similarity"] >= PARTIAL_THRESHOLD:
            return LibrarianVerdict(
                item=inbox_item,
                match_type=MatchType.PARTIAL,
                matched_name=best["name"],
                matched_source=best["source"],
                similarity=best["similarity"],
                notes=f"Partial match ({best['similarity']:.0%}): {best['name']}",
            )

        return LibrarianVerdict(
            item=inbox_item, match_type=MatchType.NONE,
            similarity=best["similarity"],
        )
