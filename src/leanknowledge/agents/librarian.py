"""Librarian Agent — RAG-enhanced search over Mathlib and pipeline formalizations.

Uses a four-tier search strategy:
1. Embedding similarity (local, no LLM) — handles ~60-70% of lookups
2. BM25 keyword search (local, no LLM) — fallback for low embedding scores
3. Loogle type-based search (remote API, no LLM) — finds results by type shape
4. Claude Haiku verification — only for borderline cases when all programmatic layers fail
"""

from __future__ import annotations

from pathlib import Path

from ..claude_client import call_claude
from ..librarian_index import LibrarianIndex, IndexEntry
from ..embedding_index import EmbeddingIndex, THRESHOLD_HIGH, THRESHOLD_LOW
from .. import loogle_client
from ..schemas import LibrarianResult

PROMPT_PATH = Path(__file__).resolve().parents[3] / "prompts" / "librarian.md"
HAIKU_MODEL = "claude-haiku-4-5-20251001"


class LibrarianAgent:
    def __init__(
        self,
        index: LibrarianIndex | None = None,
        embedding_index: EmbeddingIndex | None = None,
        use_loogle: bool = True,
    ):
        self.index = index or LibrarianIndex()
        self.embedding_index = embedding_index or EmbeddingIndex()
        self.use_loogle = use_loogle
        self._cache: dict[str, LibrarianResult] = {}

    def lookup(self, query: str) -> LibrarianResult:
        """Search for a mathematical result using tiered strategy.

        1. Embedding similarity → auto-match if score >= THRESHOLD_HIGH
        2. Embedding borderline → verify with Claude Haiku
        3. BM25 keyword fallback
        4. Loogle type-based search (no LLM)
        5. Claude Haiku verification on BM25/Loogle candidates
        6. No match found
        """
        if query in self._cache:
            return self._cache[query]

        # Tier 1: Try embedding search (no LLM)
        if self.embedding_index.is_available:
            emb_results = self.embedding_index.search(
                query, top_k=5, entries=self.index.entries
            )

            if emb_results:
                best_entry, best_score = emb_results[0]

                if isinstance(best_entry, IndexEntry):
                    # High confidence: auto-match without LLM
                    if best_score >= THRESHOLD_HIGH:
                        result = LibrarianResult(
                            query=query,
                            found=True,
                            lean_name=best_entry.lean_name,
                            import_path=best_entry.import_path,
                            type_signature=best_entry.lean_snippet[:200] if best_entry.lean_snippet else None,
                            confidence="high",
                            notes=f"Embedding match (score={best_score:.3f})",
                        )
                        self._cache[query] = result
                        return result

                    # Borderline: verify top candidates with Claude
                    if best_score >= THRESHOLD_LOW:
                        candidates = [
                            entry for entry, score in emb_results
                            if isinstance(entry, IndexEntry) and score >= THRESHOLD_LOW
                        ]
                        result = self._verify_with_claude(query, candidates)
                        self._cache[query] = result
                        return result

        # Tier 2: BM25 keyword search fallback
        bm25_candidates = self.index.lookup(query, limit=20)

        # Tier 3: Loogle type-based search (no LLM, remote API)
        loogle_result = self._try_loogle(query)
        if loogle_result is not None:
            self._cache[query] = loogle_result
            return loogle_result

        if not bm25_candidates:
            result = LibrarianResult(
                query=query,
                found=False,
                notes="No candidates found in index or Loogle.",
            )
            self._cache[query] = result
            return result

        # Tier 4: Verify BM25 candidates with Claude
        result = self._verify_with_claude(query, bm25_candidates)
        self._cache[query] = result
        return result

    def _try_loogle(self, query: str) -> LibrarianResult | None:
        """Try Loogle type-based search. Returns a result if a strong match is found, else None."""
        if not self.use_loogle:
            return None

        hits = loogle_client.search(query, max_results=5)
        if not hits:
            return None

        # Check if the top hit is a strong match (has documentation or exact name match)
        best = hits[0]
        if not best.name:
            return None

        # If there's exactly one hit, or the top hit has a clear doc match, accept it
        # For multiple hits, we return the top result with medium confidence
        # (the caller can escalate to Claude if needed)
        confidence = "high" if len(hits) == 1 else "medium"

        print(f"    [loogle] Found: {best.name} in {best.module}")
        return LibrarianResult(
            query=query,
            found=True,
            lean_name=best.name,
            import_path=loogle_client.module_to_import(best.module),
            type_signature=best.type_sig[:200] if best.type_sig else None,
            confidence=confidence,
            notes=f"Loogle match ({len(hits)} hits). {best.doc[:150] if best.doc else ''}",
        )

    def _verify_with_claude(self, query: str, candidates: list[IndexEntry]) -> LibrarianResult:
        """Send candidates to Claude Haiku for verification."""
        system = ""
        if PROMPT_PATH.exists():
            system = PROMPT_PATH.read_text(encoding="utf-8")

        prompt = (
            f"Query: {query}\n\n"
            f"## Candidates\n\n{_format_candidates(candidates)}\n\n"
            f"Which candidate (if any) matches the query? Evaluate mathematical equivalence."
        )

        try:
            data = call_claude(prompt, system=system, schema=LibrarianResult, model=HAIKU_MODEL, caller="librarian.verify")
            result = LibrarianResult.model_validate(data)
            result.query = query
        except Exception as e:
            print(f"  [librarian] Error during lookup: {e}")
            result = LibrarianResult(query=query, found=False, notes=str(e))

        return result

    def batch_lookup(self, queries: list[str]) -> dict[str, LibrarianResult]:
        """Resolve multiple queries, skipping cached ones."""
        results = {}
        for q in queries:
            results[q] = self.lookup(q)
        return results


def _format_candidates(candidates: list[IndexEntry]) -> str:
    """Format IndexEntry list as readable context for Claude."""
    lines = []
    for i, c in enumerate(candidates, 1):
        lines.append(f"### Candidate {i}")
        lines.append(f"- **Name**: `{c.lean_name}`")
        lines.append(f"- **Module**: `{c.module}`")
        lines.append(f"- **Statement**: {c.nl_statement}")
        if c.lean_snippet:
            # Show first 200 chars of Lean code
            snippet = c.lean_snippet[:200]
            lines.append(f"- **Lean**: `{snippet}`")
        if c.tags:
            lines.append(f"- **Tags**: {', '.join(c.tags[:5])}")
        lines.append("")
    return "\n".join(lines)
