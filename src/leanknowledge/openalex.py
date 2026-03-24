"""OpenAlex citation-graph client — fetch, rank, and download academic papers.

Fetches the most-cited papers for a given OpenAlex concept (default:
Microeconomics C175444787), builds an internal citation graph with NetworkX,
runs PageRank to rank by influence, and downloads open-access PDFs.

Design choices:
  - urllib.request only (no new HTTP deps)
  - JSONL incremental save — survives crashes mid-fetch
  - Resumable via ``_fetch_state.json`` (cursor + count)
  - Internal edges only (set intersection, no extra API calls)
  - ``load_openalex()`` adapter for the LeanKnowledge pipeline
"""

from __future__ import annotations

import json
import logging
import os
import time
import urllib.error
import urllib.parse
import urllib.request
from dataclasses import dataclass, field
from pathlib import Path
from typing import Any

logger = logging.getLogger(__name__)

# OpenAlex polite-pool header: a mailto contact is required for faster API access.
# See https://docs.openalex.org/how-to-use-the-api/rate-limits-and-authentication
_USER_AGENT = "LeanKnowledge/0.2 (mailto:leanknowledge@protonmail.com)"

# Default concept: Microeconomics
DEFAULT_CONCEPT_ID = "C175444787"


# ---------------------------------------------------------------------------
# Data types
# ---------------------------------------------------------------------------

@dataclass
class Author:
    """An author from an OpenAlex work."""
    name: str
    openalex_id: str = ""


@dataclass
class Paper:
    """A single work fetched from OpenAlex."""
    openalex_id: str
    doi: str = ""
    title: str = ""
    publication_year: int | None = None
    cited_by_count: int = 0
    authors: list[Author] = field(default_factory=list)
    abstract: str = ""
    referenced_works: list[str] = field(default_factory=list)  # OpenAlex IDs
    open_access_url: str = ""
    concepts: list[str] = field(default_factory=list)  # concept display names

    def to_dict(self) -> dict[str, Any]:
        return {
            "openalex_id": self.openalex_id,
            "doi": self.doi,
            "title": self.title,
            "publication_year": self.publication_year,
            "cited_by_count": self.cited_by_count,
            "authors": [{"name": a.name, "openalex_id": a.openalex_id} for a in self.authors],
            "abstract": self.abstract,
            "referenced_works": self.referenced_works,
            "open_access_url": self.open_access_url,
            "concepts": self.concepts,
        }

    @classmethod
    def from_dict(cls, d: dict[str, Any]) -> Paper:
        return cls(
            openalex_id=d["openalex_id"],
            doi=d.get("doi", ""),
            title=d.get("title", ""),
            publication_year=d.get("publication_year"),
            cited_by_count=d.get("cited_by_count", 0),
            authors=[Author(name=a["name"], openalex_id=a.get("openalex_id", ""))
                     for a in d.get("authors", [])],
            abstract=d.get("abstract", ""),
            referenced_works=d.get("referenced_works", []),
            open_access_url=d.get("open_access_url", ""),
            concepts=d.get("concepts", []),
        )


@dataclass
class RankedPaper:
    """A paper with PageRank and degree statistics."""
    rank: int
    paper: Paper
    pagerank: float = 0.0
    in_degree: int = 0   # citations from other papers in set
    out_degree: int = 0  # references to other papers in set

    def to_dict(self) -> dict[str, Any]:
        d = self.paper.to_dict()
        d["rank"] = self.rank
        d["pagerank"] = self.pagerank
        d["in_degree"] = self.in_degree
        d["out_degree"] = self.out_degree
        return d

    @classmethod
    def from_dict(cls, d: dict[str, Any]) -> RankedPaper:
        return cls(
            rank=d["rank"],
            paper=Paper.from_dict(d),
            pagerank=d.get("pagerank", 0.0),
            in_degree=d.get("in_degree", 0),
            out_degree=d.get("out_degree", 0),
        )


# ---------------------------------------------------------------------------
# Abstract reconstruction
# ---------------------------------------------------------------------------

def reconstruct_abstract(inverted_index: dict[str, list[int]] | None) -> str:
    """Reassemble abstract text from OpenAlex's inverted index format.

    OpenAlex stores abstracts as ``{"word": [pos0, pos1, ...], ...}``.
    We invert back to positional order.
    """
    if not inverted_index:
        return ""
    # Build position → word mapping
    words: dict[int, str] = {}
    for word, positions in inverted_index.items():
        for pos in positions:
            words[pos] = word
    if not words:
        return ""
    max_pos = max(words.keys())
    return " ".join(words.get(i, "") for i in range(max_pos + 1))


def _strip_openalex_url(url_or_id: str | None) -> str:
    """Extract the OpenAlex ID from a full URL or return as-is.

    ``https://openalex.org/W123`` → ``W123``
    ``W123`` → ``W123``
    ``None`` → ``""``
    """
    if not url_or_id:
        return ""
    if url_or_id.startswith("https://openalex.org/"):
        return url_or_id[len("https://openalex.org/"):]
    return url_or_id


# ---------------------------------------------------------------------------
# OpenAlex HTTP client
# ---------------------------------------------------------------------------

class OpenAlexClient:
    """Rate-limited HTTP client for the OpenAlex API.

    Uses cursor-based pagination for efficient retrieval.  Saves progress
    incrementally as JSONL and persists a ``_fetch_state.json`` file for
    resumability.

    Args:
        api_key: OpenAlex API key (or None for polite pool).
        rate_limit: Minimum seconds between API calls.
        timeout: HTTP timeout in seconds.
    """

    BASE_URL = "https://api.openalex.org"

    def __init__(
        self,
        api_key: str | None = None,
        rate_limit: float = 0.15,
        timeout: float = 30.0,
    ):
        self._api_key = api_key or os.environ.get("OPENALEX_API_KEY", "")
        self._rate_limit = rate_limit
        self._timeout = timeout
        self._last_call: float = 0.0

    def fetch_papers(
        self,
        concept_id: str = DEFAULT_CONCEPT_ID,
        max_papers: int = 5000,
        output_dir: Path | str = Path("data/openalex"),
        per_page: int = 200,
        min_citations: int = 0,
    ) -> list[Paper]:
        """Fetch top papers by citation count for a concept.

        Papers are saved incrementally to ``papers.jsonl`` in *output_dir*.
        A ``_fetch_state.json`` file tracks progress for resumability.

        Args:
            min_citations: Only fetch papers with more than this many citations.
                If 0, no citation filter is applied.

        Returns the full list of papers.
        """
        output_dir = Path(output_dir)
        output_dir.mkdir(parents=True, exist_ok=True)

        jsonl_path = output_dir / "papers.jsonl"
        state_path = output_dir / "_fetch_state.json"

        # Load existing state for resumability
        papers: list[Paper] = []
        cursor = "*"
        if state_path.exists():
            state = json.loads(state_path.read_text(encoding="utf-8"))
            cursor = state.get("cursor", "*")
            existing_count = state.get("count", 0)
            # Reload already-fetched papers
            if jsonl_path.exists():
                papers = load_papers_jsonl(jsonl_path)
            if max_papers and len(papers) >= max_papers:
                logger.info("Already have %d papers, nothing to fetch", len(papers))
                return papers[:max_papers]
            logger.info(
                "Resuming from cursor=%s, have %d papers",
                cursor[:20], len(papers),
            )

        remaining = (max_papers - len(papers)) if max_papers else float("inf")
        concept_id_bare = _strip_openalex_url(concept_id)

        # Build filter
        filter_parts = [f"concepts.id:{concept_id_bare}"]
        if min_citations > 0:
            filter_parts.append(f"cited_by_count:>{min_citations}")
        filter_str = ",".join(filter_parts)

        while remaining > 0:
            page_size = min(per_page, remaining) if max_papers else per_page
            params = {
                "filter": filter_str,
                "sort": "cited_by_count:desc",
                "per_page": str(page_size),
                "cursor": cursor,
            }
            if self._api_key:
                params["api_key"] = self._api_key

            url = f"{self.BASE_URL}/works?{urllib.parse.urlencode(params)}"
            data = self._get_json(url)
            if data is None:
                logger.error("API request failed, stopping fetch")
                break

            results = data.get("results", [])
            if not results:
                logger.info("No more results from API")
                break

            page_papers = [self._parse_work(w) for w in results]
            papers.extend(page_papers)

            # Append to JSONL
            with open(jsonl_path, "a", encoding="utf-8") as f:
                for p in page_papers:
                    f.write(json.dumps(p.to_dict()) + "\n")

            # Update cursor
            meta = data.get("meta", {})
            next_cursor = meta.get("next_cursor")
            if not next_cursor:
                logger.info("No next cursor, reached end of results")
                break
            cursor = next_cursor

            # Save state
            state_path.write_text(
                json.dumps({"cursor": cursor, "count": len(papers)}),
                encoding="utf-8",
            )

            remaining = (max_papers - len(papers)) if max_papers else float("inf")
            logger.info("Fetched %d papers so far", len(papers))

        # Clean up state file on completion
        if state_path.exists():
            if not max_papers or len(papers) >= max_papers or not results:
                state_path.unlink()

        return papers[:max_papers] if max_papers else papers

    def _get_json(self, url: str) -> dict | None:
        """Make a rate-limited GET request and return parsed JSON."""
        elapsed = time.monotonic() - self._last_call
        if elapsed < self._rate_limit:
            time.sleep(self._rate_limit - elapsed)

        headers = {"User-Agent": _USER_AGENT}
        req = urllib.request.Request(url, headers=headers)

        try:
            with urllib.request.urlopen(req, timeout=self._timeout) as resp:
                raw = resp.read().decode("utf-8")
        except (urllib.error.URLError, urllib.error.HTTPError, OSError, TimeoutError) as exc:
            logger.warning("OpenAlex request failed: %s", exc)
            self._last_call = time.monotonic()
            return None

        self._last_call = time.monotonic()

        try:
            return json.loads(raw)
        except json.JSONDecodeError:
            logger.warning("OpenAlex returned invalid JSON")
            return None

    @staticmethod
    def _parse_work(work: dict) -> Paper:
        """Parse a single OpenAlex work object into a Paper."""
        oa_id = _strip_openalex_url(work.get("id", ""))
        doi = work.get("doi") or ""
        if doi.startswith("https://doi.org/"):
            doi = doi[len("https://doi.org/"):]

        authors = []
        for authorship in work.get("authorships", []):
            author_info = authorship.get("author", {})
            authors.append(Author(
                name=author_info.get("display_name", ""),
                openalex_id=_strip_openalex_url(author_info.get("id", "")),
            ))

        abstract = reconstruct_abstract(work.get("abstract_inverted_index"))

        referenced = [
            _strip_openalex_url(ref)
            for ref in work.get("referenced_works", [])
        ]

        oa = work.get("open_access", {})
        oa_url = oa.get("oa_url") or ""

        concepts = [
            c.get("display_name", "")
            for c in work.get("concepts", [])
            if c.get("display_name")
        ]

        return Paper(
            openalex_id=oa_id,
            doi=doi,
            title=work.get("title") or "",
            publication_year=work.get("publication_year"),
            cited_by_count=work.get("cited_by_count", 0),
            authors=authors,
            abstract=abstract,
            referenced_works=referenced,
            open_access_url=oa_url,
            concepts=concepts,
        )


# ---------------------------------------------------------------------------
# JSONL persistence
# ---------------------------------------------------------------------------

def load_papers_jsonl(path: Path | str) -> list[Paper]:
    """Load papers from a JSONL file."""
    papers = []
    with open(path, "r", encoding="utf-8") as f:
        for line in f:
            line = line.strip()
            if line:
                papers.append(Paper.from_dict(json.loads(line)))
    return papers


def save_papers_jsonl(papers: list[Paper], path: Path | str) -> None:
    """Save papers to a JSONL file (overwrite)."""
    with open(path, "w", encoding="utf-8") as f:
        for p in papers:
            f.write(json.dumps(p.to_dict()) + "\n")


# ---------------------------------------------------------------------------
# Citation graph
# ---------------------------------------------------------------------------

def build_citation_graph(papers: list[Paper]) -> Any:
    """Build a NetworkX DiGraph from paper citations.

    Nodes are OpenAlex IDs.  Edges are directed: A → B means A cites B.
    Only edges between papers in the input set are included (set intersection).

    Returns a ``networkx.DiGraph``.
    """
    import networkx as nx

    paper_ids = {p.openalex_id for p in papers}
    paper_map = {p.openalex_id: p for p in papers}

    G = nx.DiGraph()

    # Add all papers as nodes
    for p in papers:
        G.add_node(p.openalex_id, title=p.title, year=p.publication_year)

    # Add edges (only between papers in our set)
    for p in papers:
        for ref_id in p.referenced_works:
            if ref_id in paper_ids:
                G.add_edge(p.openalex_id, ref_id)

    return G


def rank_papers(papers: list[Paper], graph: Any = None) -> list[RankedPaper]:
    """Rank papers using PageRank on their citation graph.

    Args:
        papers: List of papers to rank.
        graph: Pre-built citation graph (optional; built if not provided).

    Returns:
        Papers sorted by PageRank score (descending), with rank and degree stats.
    """
    import networkx as nx

    if graph is None:
        graph = build_citation_graph(papers)

    paper_map = {p.openalex_id: p for p in papers}

    # Run PageRank
    try:
        scores = nx.pagerank(graph, alpha=0.85, max_iter=100)
    except nx.PowerIterationFailedConvergence:
        logger.warning("PageRank did not converge, using uniform scores")
        scores = {node: 1.0 / len(graph) for node in graph}

    # Build ranked list
    ranked = []
    for oa_id, score in scores.items():
        if oa_id not in paper_map:
            continue
        ranked.append(RankedPaper(
            rank=0,  # assigned below
            paper=paper_map[oa_id],
            pagerank=score,
            in_degree=graph.in_degree(oa_id),
            out_degree=graph.out_degree(oa_id),
        ))

    # Sort by PageRank descending
    ranked.sort(key=lambda r: r.pagerank, reverse=True)

    # Assign ranks (1-indexed)
    for i, r in enumerate(ranked):
        r.rank = i + 1

    return ranked


# ---------------------------------------------------------------------------
# Graph persistence
# ---------------------------------------------------------------------------

def save_graph(graph: Any, path: Path | str) -> None:
    """Save a citation graph as JSON (node list + edge list)."""
    data = {
        "nodes": [
            {"id": n, **graph.nodes[n]}
            for n in graph.nodes
        ],
        "edges": [
            {"source": u, "target": v}
            for u, v in graph.edges
        ],
    }
    Path(path).write_text(json.dumps(data, indent=2), encoding="utf-8")


def load_graph(path: Path | str) -> Any:
    """Load a citation graph from JSON."""
    import networkx as nx

    data = json.loads(Path(path).read_text(encoding="utf-8"))
    G = nx.DiGraph()

    for node in data["nodes"]:
        node_id = node.pop("id")
        G.add_node(node_id, **node)

    for edge in data["edges"]:
        G.add_edge(edge["source"], edge["target"])

    return G


def save_ranked(ranked: list[RankedPaper], path: Path | str) -> None:
    """Save ranked papers to JSON."""
    data = [r.to_dict() for r in ranked]
    Path(path).write_text(json.dumps(data, indent=2), encoding="utf-8")


def load_ranked(path: Path | str) -> list[RankedPaper]:
    """Load ranked papers from JSON."""
    data = json.loads(Path(path).read_text(encoding="utf-8"))
    return [RankedPaper.from_dict(d) for d in data]


# ---------------------------------------------------------------------------
# PDF downloader
# ---------------------------------------------------------------------------

def download_pdfs(
    ranked: list[RankedPaper],
    output_dir: Path | str,
    top_n: int = 100,
    rate_limit: float = 1.0,
) -> dict[str, Path]:
    """Download open-access PDFs for the top-N ranked papers.

    Returns a mapping from OpenAlex ID to the local PDF path.
    Skips papers without an open-access URL and already-downloaded files.
    """
    output_dir = Path(output_dir)
    output_dir.mkdir(parents=True, exist_ok=True)

    downloaded: dict[str, Path] = {}
    last_download = 0.0

    for rp in ranked[:top_n]:
        url = rp.paper.open_access_url
        if not url:
            continue

        # Build filename from rank + sanitized title
        safe_title = "".join(
            c if c.isalnum() or c in " -_" else ""
            for c in (rp.paper.title or "untitled")
        )[:80].strip()
        filename = f"{rp.rank:04d}_{safe_title}.pdf"
        filepath = output_dir / filename

        if filepath.exists():
            downloaded[rp.paper.openalex_id] = filepath
            continue

        # Rate limit
        elapsed = time.monotonic() - last_download
        if elapsed < rate_limit:
            time.sleep(rate_limit - elapsed)

        try:
            req = urllib.request.Request(url, headers={"User-Agent": _USER_AGENT})
            with urllib.request.urlopen(req, timeout=60) as resp:
                content = resp.read()

            filepath.write_bytes(content)
            downloaded[rp.paper.openalex_id] = filepath
            logger.info("Downloaded: %s (%s)", filename, rp.paper.openalex_id)
        except (urllib.error.URLError, urllib.error.HTTPError, OSError, TimeoutError) as exc:
            logger.warning("Failed to download %s: %s", rp.paper.openalex_id, exc)

        last_download = time.monotonic()

    return downloaded


# ---------------------------------------------------------------------------
# Pipeline adapter
# ---------------------------------------------------------------------------

def load_openalex(
    ranked_path: Path | str,
    top_n: int | None = None,
) -> list[dict[str, Any]]:
    """Load ranked OpenAlex papers as pipeline-ready dicts.

    Similar to ``load_proofwiki()`` — returns a list of dicts with keys
    ``title``, ``abstract``, ``source``, ``doi``, ``year``, ``rank``,
    ``pagerank``, ``open_access_url``.

    Args:
        ranked_path: Path to ``ranked_papers.json``.
        top_n: Limit to top N papers (None = all).

    Returns:
        List of dicts suitable for pipeline ingestion.
    """
    ranked = load_ranked(ranked_path)
    if top_n is not None:
        ranked = ranked[:top_n]

    results = []
    for rp in ranked:
        results.append({
            "title": rp.paper.title,
            "abstract": rp.paper.abstract,
            "source": f"OpenAlex:{rp.paper.openalex_id}",
            "doi": rp.paper.doi,
            "year": rp.paper.publication_year,
            "rank": rp.rank,
            "pagerank": rp.pagerank,
            "open_access_url": rp.paper.open_access_url,
            "authors": [a.name for a in rp.paper.authors],
        })
    return results
