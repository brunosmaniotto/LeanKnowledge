"""Feeder Agent — Procurement agent that finds source material for backlog items.

The Feeder takes 'blocked' backlog items (which need external proofs) and tries to locate
them in the available `Sources/` directory or identifies them as standard results.
"""

from dataclasses import dataclass
from pathlib import Path
from typing import Literal, Optional
import json

from ..schemas import BacklogEntry, ClaimRole
from ..claude_client import call_claude
from ..bib_index import BibIndex

PROMPT_PATH = Path(__file__).resolve().parents[3] / "prompts" / "feeder.md"


@dataclass
class FeederResult:
    """Result of a feeder search attempt."""
    found: bool
    source_type: Literal["pdf_page", "mathlib_source", "text_excerpt", "not_found"]
    source_path: Path | None = None
    page_range: tuple[int, int] | None = None
    excerpt: str | None = None
    notes: str | None = None


class FeederAgent:
    def __init__(
        self,
        sources_dir: Path = Path("Sources"),
        call_fn=None,
        bib_index: BibIndex | None = None,
        citation_suggester=None
    ):
        self.sources_dir = sources_dir
        self.call_fn = call_fn or call_claude
        self.bib_index = bib_index or BibIndex()
        self.citation_suggester = citation_suggester
        self._sources_cache: list[str] | None = None

    @property
    def available_sources(self) -> list[str]:
        """List available PDF sources."""
        if self._sources_cache is None:
            if self.sources_dir.exists():
                self._sources_cache = [p.name for p in self.sources_dir.glob("**/*.pdf")]
            else:
                self._sources_cache = []
        return self._sources_cache

    def process_backlog(self, entries: list[BacklogEntry], max_items: int = 10) -> list[FeederResult]:
        """Process multiple backlog entries."""
        results = []
        count = 0
        for entry in entries:
            if count >= max_items:
                break
            result = self.find_source(entry)
            results.append(result)
            if result.found:
                count += 1
        return results

    def find_source(self, entry: BacklogEntry) -> FeederResult:
        """Attempt to find source material for a backlog entry."""
        
        # Dispatch based on category/role
        if entry.category == "referenced":
            return self._search_referenced(entry)
        elif entry.category == "unreferenced":
            return self._search_unreferenced(entry)
        elif entry.category == "omitted_proof":
            return self._search_omitted(entry)
        else:
            # Fallback based on role
            if entry.item.role == ClaimRole.INVOKED_DEPENDENCY:
                return self._search_unreferenced(entry)
            else:
                return FeederResult(
                    found=False,
                    source_type="not_found",
                    notes=f"Unknown category {entry.category}"
                )

    def _search_referenced(self, entry: BacklogEntry) -> FeederResult:
        """Category 1: Follow the explicit reference."""
        # Check if we can identify the source from the statement or notes
        # "by Theorem 4.3 in Rudin"
        
        # 1. Ask LLM to parse the reference and match to available sources
        system = PROMPT_PATH.read_text(encoding="utf-8")
        
        # Prepare context
        # Search BibIndex for hints
        bib_hints = []
        if self.bib_index:
            # Simple keyword extraction from statement
            # This is naive; a better approach would be LLM extraction of keywords
            # But we can just dump the top hits for the statement
            hits = self.bib_index.search(entry.item.statement[:100]) # truncated query
            bib_hints = [f"{h.key}: {h.title} by {', '.join(h.authors)}" for h in hits[:3]]

        # Citation graph suggestions
        citation_hints = []
        if self.citation_suggester:
            suggestions = self.citation_suggester.suggest(
                entry.item.statement, domain=entry.domain.value, top_k=3
            )
            citation_hints = [
                f"{s.title} ({s.year}, {s.venue}) — relevance: {s.relevance_score:.0%}"
                for s in suggestions
            ]

        prompt = (
            f"Claim to prove: {entry.item.statement}\n"
            f"Context: {entry.item.context or ''}\n"
            f"Notes: {entry.item.proof or ''} {entry.item.proof_sketch or ''}\n\n"
            f"Available Sources in Sources/:\n" + "\n".join(self.available_sources) + "\n\n"
            f"Relevant BibTeX entries:\n" + "\n".join(bib_hints) + "\n\n"
        )

        if citation_hints:
            prompt += f"Related papers from citation graph:\n" + "\n".join(citation_hints) + "\n\n"

        prompt += f"Task: Identify the source file and page range."

        response = self.call_fn(
            prompt,
            system=system,
            caller="feeder.search_referenced",
            model="claude-3-haiku-20240307" # Use faster model for simple search
        )
        
        # We need to parse the response. Since we didn't enforce schema (or did we?),
        # let's assume _extract_json behavior or similar.
        # The prompt says "Respond with a JSON object".
        
        if isinstance(response, str):
             # Try to parse if it returned a string (call_claude typically returns dict if schema provided, or str/dict otherwise)
             # Here we didn't provide schema to call_fn, so likely string.
             # Use the helper from claude_client if available, but it's internal.
             # Let's do simple json parse.
             try:
                 # Clean markdown code blocks
                 if "```json" in response:
                     response = response.split("```json")[1].split("```")[0].strip()
                 elif "```" in response:
                     response = response.split("```")[1].split("```")[0].strip()
                 data = json.loads(response)
             except:
                 data = {"found": False, "reasoning": "Failed to parse response"}
        else:
            data = response

        if data.get("found"):
            source_file = data.get("source_file")
            # Verify file exists
            path = self.sources_dir / source_file
            if not path.exists():
                 return FeederResult(found=False, source_type="not_found", notes=f"LLM suggested {source_file} but it does not exist.")
            
            # Parse location
            loc = data.get("location", "")
            pages = None
            if "-" in str(loc):
                try:
                    start, end = map(int, str(loc).split("-"))
                    pages = (start, end)
                except:
                    pass
            elif str(loc).isdigit():
                p = int(loc)
                pages = (p, p)
            
            return FeederResult(
                found=True,
                source_type="pdf_page",
                source_path=path,
                page_range=pages,
                notes=data.get("reasoning")
            )
            
        return FeederResult(found=False, source_type="not_found", notes=data.get("reasoning"))

    def _search_unreferenced(self, entry: BacklogEntry) -> FeederResult:
        """Category 2: Search available sources for the result."""
        # For now, similar logic to referenced, but we ask "Where is this?"
        # Future: Use vector search over textbook chunks.
        
        # Citation graph suggestions
        citation_hints = []
        if self.citation_suggester:
            suggestions = self.citation_suggester.suggest(
                entry.item.statement, domain=entry.domain.value, top_k=3
            )
            citation_hints = [
                f"{s.title} ({s.year}, {s.venue}) — relevance: {s.relevance_score:.0%}"
                for s in suggestions
            ]

        system = PROMPT_PATH.read_text(encoding="utf-8")
        prompt = (
            f"Unreferenced claim: {entry.item.statement}\n"
            f"Domain: {entry.domain}\n"
            f"Context: {entry.item.context}\n\n"
            f"Available Sources:\n" + "\n".join(self.available_sources) + "\n\n"
        )
        
        if citation_hints:
            prompt += f"Related papers from citation graph:\n" + "\n".join(citation_hints) + "\n\n"
        
        prompt += f"Which of these sources is most likely to contain a proof for this claim?"
        
        response = self.call_fn(
            prompt,
            system=system,
            caller="feeder.search_unreferenced",
            model="claude-3-haiku-20240307"
        )
        
        # (Parsing logic duplicated - simplified for brevity)
        try:
             if isinstance(response, str):
                 if "```json" in response:
                     response = response.split("```json")[1].split("```")[0].strip()
                 elif "```" in response:
                     response = response.split("```")[1].split("```")[0].strip()
                 data = json.loads(response)
             else:
                 data = response
        except:
             return FeederResult(found=False, source_type="not_found", notes="Failed to parse LLM response")

        if data.get("found"):
            source_file = data.get("source_file")
            path = self.sources_dir / source_file
            if path.exists():
                return FeederResult(
                    found=True,
                    source_type="pdf_page",
                    source_path=path,
                    page_range=None, # Usually LLM can't guess page of unreferenced item without search index
                    notes=f"Suggested source: {source_file}. {data.get('reasoning')}"
                )
        
        return FeederResult(found=False, source_type="not_found", notes=data.get("reasoning"))

    def _search_omitted(self, entry: BacklogEntry) -> FeederResult:
        """Category 3: Try to find the result elsewhere."""
        # Treat same as unreferenced for now
        return self._search_unreferenced(entry)
