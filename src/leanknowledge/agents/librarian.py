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

from __future__ import annotations

import logging
from dataclasses import dataclass, field
from difflib import SequenceMatcher
from enum import Enum
from typing import TYPE_CHECKING

from .triage import TriageBatch, InboxItem, ItemCategory

if TYPE_CHECKING:
    from ..loogle import LoogleClient
    from ..mathlib_index import MathlibIndex

logger = logging.getLogger(__name__)


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

EXACT_THRESHOLD = 0.95    # above this → exact match (skip). Raised from 0.90 after
                          # cross-book dedup audit showed 65% false positive rate at 0.90.
                          # At 0.95 only near-identical name matches trigger (dot vs underscore).
PARTIAL_THRESHOLD = 0.50  # above this → partial match (backlog with warm-start reference)


# ---------------------------------------------------------------------------
# Main agent
# ---------------------------------------------------------------------------

class LibrarianAgent:
    """Agent 4: Check inbox items against existing formalized content."""

    def __init__(self, library: Library):
        self.library = library

    def check(self, batch: TriageBatch) -> LibrarianResult:
        """Check every item in a triage batch against the library.

        Args:
            batch: classified items from Agent 3

        Returns:
            LibrarianResult with items sorted into exact/partial/no match.
        """
        result = LibrarianResult()

        for inbox_item in batch.items:
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


# ---------------------------------------------------------------------------
# Loogle-backed library (production backend for Mathlib dedup)
# ---------------------------------------------------------------------------

class LoogleLibrary(Library):
    """Uses the Loogle API for type-based search against Mathlib.

    When checking an inbox item:
      - Searches Loogle by the item's statement text
      - An exact name match (Loogle hit name == item ID) → EXACT
      - A high-similarity type match → EXACT (similarity ≥ exact_threshold)
      - Any hit at all → PARTIAL (Loogle results are inherently relevant)
      - No hits → NO_MATCH

    Args:
        client: A :class:`~leanknowledge.loogle.LoogleClient` instance.
            Created lazily if not provided.
        exact_threshold: SequenceMatcher ratio above which a Loogle hit
            is considered an exact match on statement text.
    """

    def __init__(
        self,
        client: LoogleClient | None = None,
        exact_threshold: float = 0.85,
    ):
        # Lazy import to avoid circular deps / hard dependency on loogle module
        from ..loogle import LoogleClient as _LoogleClient
        self._client = client or _LoogleClient()
        self._exact_threshold = exact_threshold

    def search(self, statement: str, name: str = "") -> list[dict]:
        """Search Loogle for matching Mathlib declarations.

        Returns results as dicts with keys: name, source, statement, similarity.
        """
        try:
            hits = self._client.search(statement, num_results=10)
        except Exception as exc:
            logger.warning("LoogleLibrary.search failed: %s", exc)
            return []

        if not hits:
            return []

        results: list[dict] = []
        norm_name = _normalize(name)

        for hit in hits:
            # Compute similarity between the item statement and the Loogle
            # hit's type signature (this is the best proxy for semantic match)
            hit_text = hit.type_sig or hit.name
            stmt_sim = SequenceMatcher(
                None, _normalize(statement), _normalize(hit_text)
            ).ratio()

            # Boost if name matches
            if norm_name:
                name_sim = SequenceMatcher(
                    None, norm_name, _normalize(hit.name)
                ).ratio()
                similarity = max(stmt_sim, name_sim)
            else:
                similarity = stmt_sim

            # Loogle results are inherently relevant (type-based search), so
            # give a minimum similarity floor of 0.55 to ensure they register
            # as at least PARTIAL_MATCH
            similarity = max(similarity, 0.55)

            results.append({
                "name": hit.name,
                "source": "mathlib",
                "statement": hit.type_sig,
                "similarity": similarity,
            })

        results.sort(key=lambda r: r["similarity"], reverse=True)
        return results


# ---------------------------------------------------------------------------
# Rosetta Stone library (TF-IDF over Mathlib + verified proofs)
# ---------------------------------------------------------------------------

# Scale factor for TF-IDF scores to fit the Librarian's threshold range.
# TF-IDF cosine similarity typically lands in 0.2-0.6 for good matches,
# while the Librarian expects 0.5+ for partial and 0.95+ for exact.
#
# Previous value was 1.5 which mapped raw cosine 0.60 → scaled 0.90 → skip.
# Cross-book dedup audit (J&R run, Entry 5 in JOURNAL) showed 65% false positive
# rate at this threshold. Reduced to 1.2 so that only raw cosine >= 0.79 reaches
# the exact threshold (0.95). Most TF-IDF matches become warm-start references
# (partial) rather than skip signals.
TFIDF_SCORE_SCALE = 1.2


class RosettaStoneLibrary(Library):
    """Production Librarian backend — TF-IDF search over Mathlib + Rosetta Stone.

    Wraps MathlibIndex to check incoming items against:
      - 207K Mathlib declarations (name, signature, docstring)
      - All previously-verified proofs from pipeline runs (statement, lean_code)

    This catches:
      - Theorems already in Mathlib (don't re-prove)
      - Theorems we've already proved in previous runs (don't duplicate)
      - Semantically similar theorems (mathematical vocabulary overlap)

    TF-IDF scores are scaled by a factor of 1.5 (capped at 1.0) so they
    align with the Librarian's existing thresholds (0.50 partial, 0.90 exact).

    Args:
        mathlib_index: A MathlibIndex instance (with declarations loaded).
        top_k: Number of search results to consider per query (default 5).
        score_scale: Multiplier for raw TF-IDF scores (default 1.5).
    """

    def __init__(
        self,
        mathlib_index: MathlibIndex,
        top_k: int = 5,
        score_scale: float = TFIDF_SCORE_SCALE,
    ):
        self._index = mathlib_index
        self._top_k = top_k
        self._score_scale = score_scale

    def search(self, statement: str, name: str = "") -> list[dict]:
        """Search Mathlib + Rosetta Stone for matching declarations.

        Searches by statement text. Also searches by name if provided.
        Returns the best results from either query, deduplicated by name
        (keeping the highest score).
        """
        if self._index.size == 0:
            return []

        # Collect results keyed by declaration name (best score wins)
        best: dict[str, dict] = {}

        # Primary search: by statement text
        for r in self._index.search(statement, top_k=self._top_k):
            scaled = min(r.score * self._score_scale, 1.0)
            entry = {
                "name": r.name,
                "source": r.source,
                "statement": r.signature or r.docstring,
                "similarity": scaled,
            }
            if r.name not in best or scaled > best[r.name]["similarity"]:
                best[r.name] = entry

        # Secondary search: by name (if provided)
        if name:
            for r in self._index.search(name, top_k=self._top_k):
                scaled = min(r.score * self._score_scale, 1.0)
                entry = {
                    "name": r.name,
                    "source": r.source,
                    "statement": r.signature or r.docstring,
                    "similarity": scaled,
                }
                if r.name not in best or scaled > best[r.name]["similarity"]:
                    best[r.name] = entry

        results = list(best.values())
        results.sort(key=lambda r: r["similarity"], reverse=True)
        return results


class StackedLibrary(Library):
    """Cascading search: tries each backend in order, returns first match.

    When a backend returns results with similarity above the partial threshold,
    those results are returned immediately.  Otherwise the next backend is
    tried.  If no backend produces matches, an empty list is returned.

    This lets you compose e.g. ``StackedLibrary([LoogleLibrary(), InMemoryLibrary()])``
    to check Mathlib first, then fall back to a local knowledge tree.
    """

    def __init__(self, backends: list[Library]):
        if not backends:
            raise ValueError("StackedLibrary requires at least one backend")
        self._backends = backends

    def search(self, statement: str, name: str = "") -> list[dict]:
        """Search backends in order. Return results from the first backend
        that produces any hits with similarity >= PARTIAL_THRESHOLD."""
        for backend in self._backends:
            try:
                results = backend.search(statement=statement, name=name)
            except Exception as exc:
                logger.warning("StackedLibrary: backend %s failed: %s",
                               type(backend).__name__, exc)
                continue
            if results and results[0].get("similarity", 0) >= PARTIAL_THRESHOLD:
                return results
        # No backend had a strong match — return results from the last
        # backend that had *any* results, or empty
        for backend in self._backends:
            try:
                results = backend.search(statement=statement, name=name)
                if results:
                    return results
            except Exception:
                continue
        return []
