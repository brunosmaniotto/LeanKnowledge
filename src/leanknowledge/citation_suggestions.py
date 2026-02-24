"""Citation graph suggestions for the Feeder Agent.

Loads the economics citation graph and provides keyword-based paper suggestions.
This is a lightweight search — no embeddings, just title/abstract keyword matching.
"""

import json
from dataclasses import dataclass
from pathlib import Path


@dataclass
class PaperSuggestion:
    """A suggested paper that might contain relevant proofs."""
    paper_id: str
    title: str
    year: int | None
    venue: str | None
    authors: list[str]
    abstract: str | None
    relevance_score: float  # 0-1, based on keyword overlap


CITATION_DATA_DIR = Path(__file__).resolve().parents[2] / "citation_graph" / "data"


class CitationSuggester:
    """Suggests relevant papers from the citation graph for blocked backlog items."""

    def __init__(self, data_dir: Path = CITATION_DATA_DIR):
        self.data_dir = data_dir
        self._papers: dict | None = None

    @property
    def papers(self) -> dict:
        if self._papers is None:
            self._papers = {}
            papers_file = self.data_dir / "papers.json"
            if papers_file.exists():
                try:
                    self._papers = json.loads(papers_file.read_text(encoding="utf-8"))
                except (json.JSONDecodeError, OSError):
                    self._papers = {}
        return self._papers

    def suggest(self, query: str, domain: str | None = None, top_k: int = 5) -> list[PaperSuggestion]:
        """Find papers whose title or abstract matches keywords from the query.

        Args:
            query: The theorem statement or description to find sources for.
            domain: Optional domain filter (e.g., "microeconomics", "game_theory").
            top_k: Number of suggestions to return.

        Returns:
            List of PaperSuggestion sorted by relevance_score descending.
        """
        if not self.papers:
            return []

        # Extract keywords from query (simple: split on whitespace, filter short words)
        keywords = set()
        for word in query.lower().split():
            # Strip punctuation
            clean = word.strip(".,;:()[]{}\"'")
            if len(clean) > 3 and clean not in _STOP_WORDS:
                keywords.add(clean)

        if not keywords:
            return []

        scored = []
        for paper_id, paper in self.papers.items():
            title = (paper.get("title") or "").lower()
            abstract = (paper.get("abstract") or "").lower()
            searchable = f"{title} {abstract}"

            # Count keyword matches
            matches = sum(1 for kw in keywords if kw in searchable)
            if matches == 0:
                continue

            score = matches / len(keywords)

            # Boost papers from relevant venues based on domain
            venue = paper.get("venue") or ""
            if domain and _venue_matches_domain(venue, domain):
                score *= 1.2  # 20% boost

            scored.append((score, paper_id, paper))

        scored.sort(key=lambda x: -x[0])

        suggestions = []
        for score, paper_id, paper in scored[:top_k]:
            suggestions.append(PaperSuggestion(
                paper_id=paper_id,
                title=paper.get("title", ""),
                year=paper.get("year"),
                venue=paper.get("venue"),
                authors=paper.get("authors", []),
                abstract=paper.get("abstract"),
                relevance_score=min(score, 1.0),
            ))

        return suggestions


def _venue_matches_domain(venue: str, domain: str) -> bool:
    """Check if a journal venue is relevant to the given domain."""
    venue_lower = venue.lower()
    domain_venues = {
        "microeconomics": ["econometrica", "american economic review", "journal of political economy",
                           "quarterly journal of economics", "review of economic studies"],
        "game_theory": ["games and economic behavior", "international journal of game theory",
                        "journal of economic theory", "theoretical economics"],
        "welfare_economics": ["social choice and welfare", "journal of public economics",
                              "american economic review"],
    }
    relevant = domain_venues.get(domain, [])
    return any(v in venue_lower for v in relevant)


_STOP_WORDS = {
    "the", "and", "for", "that", "this", "with", "from", "are", "was", "were",
    "been", "being", "have", "has", "had", "does", "did", "will", "would",
    "could", "should", "may", "might", "shall", "can", "each", "every",
    "some", "any", "all", "both", "such", "than", "then", "when", "where",
    "which", "while", "about", "above", "after", "before", "between", "into",
    "through", "during", "under", "over", "there", "here", "more", "most",
    "other", "only", "also", "very", "just", "because", "these", "those",
    "what", "show", "prove", "given", "holds", "true", "false", "proof",
}
