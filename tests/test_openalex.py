"""Tests for the OpenAlex citation-graph client."""

import json
import tempfile
from pathlib import Path
from unittest.mock import MagicMock, patch

import pytest

from leanknowledge.openalex import (
    Author,
    OpenAlexClient,
    Paper,
    RankedPaper,
    _strip_openalex_url,
    build_citation_graph,
    load_papers_jsonl,
    load_ranked,
    rank_papers,
    reconstruct_abstract,
    save_papers_jsonl,
    save_ranked,
)


# ---------------------------------------------------------------------------
# Abstract reconstruction
# ---------------------------------------------------------------------------

class TestReconstructAbstract:
    def test_basic(self):
        inv = {"This": [0], "is": [1], "a": [2], "test": [3]}
        assert reconstruct_abstract(inv) == "This is a test"

    def test_repeated_word(self):
        inv = {"the": [0, 2], "cat": [1], "dog": [3]}
        assert reconstruct_abstract(inv) == "the cat the dog"

    def test_none_returns_empty(self):
        assert reconstruct_abstract(None) == ""

    def test_empty_dict_returns_empty(self):
        assert reconstruct_abstract({}) == ""

    def test_gap_in_positions(self):
        """Gaps in positions produce empty strings at those slots."""
        inv = {"hello": [0], "world": [3]}
        result = reconstruct_abstract(inv)
        assert result == "hello   world"


# ---------------------------------------------------------------------------
# URL stripping
# ---------------------------------------------------------------------------

class TestStripUrl:
    def test_full_url(self):
        assert _strip_openalex_url("https://openalex.org/W123") == "W123"

    def test_bare_id(self):
        assert _strip_openalex_url("W123") == "W123"

    def test_concept_url(self):
        assert _strip_openalex_url("https://openalex.org/C175444787") == "C175444787"


# ---------------------------------------------------------------------------
# Paper serialization
# ---------------------------------------------------------------------------

class TestPaperSerialization:
    def test_roundtrip(self):
        p = Paper(
            openalex_id="W100",
            doi="10.1234/test",
            title="Test Paper",
            publication_year=2020,
            cited_by_count=42,
            authors=[Author(name="Alice", openalex_id="A1")],
            abstract="This is a test.",
            referenced_works=["W200", "W300"],
            open_access_url="https://example.com/paper.pdf",
            concepts=["Economics"],
        )
        d = p.to_dict()
        p2 = Paper.from_dict(d)

        assert p2.openalex_id == "W100"
        assert p2.doi == "10.1234/test"
        assert p2.title == "Test Paper"
        assert p2.publication_year == 2020
        assert p2.cited_by_count == 42
        assert len(p2.authors) == 1
        assert p2.authors[0].name == "Alice"
        assert p2.abstract == "This is a test."
        assert p2.referenced_works == ["W200", "W300"]
        assert p2.open_access_url == "https://example.com/paper.pdf"
        assert p2.concepts == ["Economics"]


class TestRankedPaperSerialization:
    def test_roundtrip(self):
        p = Paper(openalex_id="W100", title="Test")
        rp = RankedPaper(rank=1, paper=p, pagerank=0.05, in_degree=10, out_degree=3)
        d = rp.to_dict()
        rp2 = RankedPaper.from_dict(d)

        assert rp2.rank == 1
        assert rp2.pagerank == 0.05
        assert rp2.in_degree == 10
        assert rp2.out_degree == 3
        assert rp2.paper.openalex_id == "W100"


# ---------------------------------------------------------------------------
# JSONL persistence
# ---------------------------------------------------------------------------

class TestJsonlPersistence:
    def test_save_load_roundtrip(self, tmp_path):
        papers = [
            Paper(openalex_id="W1", title="Paper One", cited_by_count=100),
            Paper(openalex_id="W2", title="Paper Two", cited_by_count=50),
        ]
        path = tmp_path / "papers.jsonl"
        save_papers_jsonl(papers, path)
        loaded = load_papers_jsonl(path)

        assert len(loaded) == 2
        assert loaded[0].openalex_id == "W1"
        assert loaded[0].title == "Paper One"
        assert loaded[1].openalex_id == "W2"

    def test_empty_file(self, tmp_path):
        path = tmp_path / "empty.jsonl"
        path.write_text("", encoding="utf-8")
        assert load_papers_jsonl(path) == []


class TestRankedPersistence:
    def test_save_load_roundtrip(self, tmp_path):
        papers = [
            RankedPaper(rank=1, paper=Paper(openalex_id="W1", title="A"), pagerank=0.1),
            RankedPaper(rank=2, paper=Paper(openalex_id="W2", title="B"), pagerank=0.05),
        ]
        path = tmp_path / "ranked.json"
        save_ranked(papers, path)
        loaded = load_ranked(path)

        assert len(loaded) == 2
        assert loaded[0].rank == 1
        assert loaded[0].paper.title == "A"
        assert loaded[1].pagerank == 0.05


# ---------------------------------------------------------------------------
# Citation graph
# ---------------------------------------------------------------------------

class TestCitationGraph:
    def _make_papers(self) -> list[Paper]:
        """Create a small citation network: A→B, A→C, B→C."""
        return [
            Paper(openalex_id="A", title="Paper A", referenced_works=["B", "C"]),
            Paper(openalex_id="B", title="Paper B", referenced_works=["C"]),
            Paper(openalex_id="C", title="Paper C", referenced_works=[]),
        ]

    def test_graph_nodes(self):
        papers = self._make_papers()
        G = build_citation_graph(papers)
        assert set(G.nodes) == {"A", "B", "C"}

    def test_graph_edges(self):
        papers = self._make_papers()
        G = build_citation_graph(papers)
        assert G.has_edge("A", "B")
        assert G.has_edge("A", "C")
        assert G.has_edge("B", "C")
        assert not G.has_edge("C", "A")

    def test_external_refs_excluded(self):
        """References to papers NOT in our set should be ignored."""
        papers = [
            Paper(openalex_id="A", referenced_works=["B", "EXTERNAL"]),
            Paper(openalex_id="B", referenced_works=[]),
        ]
        G = build_citation_graph(papers)
        assert G.number_of_edges() == 1
        assert G.has_edge("A", "B")
        assert "EXTERNAL" not in G.nodes

    def test_empty_list(self):
        G = build_citation_graph([])
        assert G.number_of_nodes() == 0
        assert G.number_of_edges() == 0


# ---------------------------------------------------------------------------
# PageRank
# ---------------------------------------------------------------------------

class TestPageRank:
    def test_simple_chain(self):
        """In A→B→C, C should rank highest (most cited)."""
        papers = [
            Paper(openalex_id="A", referenced_works=["B"]),
            Paper(openalex_id="B", referenced_works=["C"]),
            Paper(openalex_id="C", referenced_works=[]),
        ]
        ranked = rank_papers(papers)

        assert ranked[0].paper.openalex_id == "C"
        assert ranked[0].rank == 1
        assert ranked[-1].paper.openalex_id == "A"

    def test_star_topology(self):
        """All point to center → center ranks highest."""
        papers = [
            Paper(openalex_id="center", referenced_works=[]),
            Paper(openalex_id="s1", referenced_works=["center"]),
            Paper(openalex_id="s2", referenced_works=["center"]),
            Paper(openalex_id="s3", referenced_works=["center"]),
        ]
        ranked = rank_papers(papers)
        assert ranked[0].paper.openalex_id == "center"

    def test_degree_stats(self):
        """Check in-degree and out-degree are computed correctly."""
        papers = [
            Paper(openalex_id="A", referenced_works=["B", "C"]),
            Paper(openalex_id="B", referenced_works=["C"]),
            Paper(openalex_id="C", referenced_works=[]),
        ]
        ranked = rank_papers(papers)

        by_id = {rp.paper.openalex_id: rp for rp in ranked}
        assert by_id["C"].in_degree == 2   # cited by A and B
        assert by_id["C"].out_degree == 0
        assert by_id["A"].in_degree == 0
        assert by_id["A"].out_degree == 2

    def test_ranks_are_1_indexed(self):
        papers = [
            Paper(openalex_id="A", referenced_works=[]),
            Paper(openalex_id="B", referenced_works=[]),
        ]
        ranked = rank_papers(papers)
        ranks = {rp.rank for rp in ranked}
        assert ranks == {1, 2}

    def test_single_paper(self):
        papers = [Paper(openalex_id="lonely")]
        ranked = rank_papers(papers)
        assert len(ranked) == 1
        assert ranked[0].rank == 1


# ---------------------------------------------------------------------------
# OpenAlexClient — work parsing
# ---------------------------------------------------------------------------

class TestParseWork:
    def test_parse_basic_work(self):
        work = {
            "id": "https://openalex.org/W100",
            "doi": "https://doi.org/10.1234/test",
            "title": "Test Paper",
            "publication_year": 2020,
            "cited_by_count": 42,
            "authorships": [
                {"author": {"display_name": "Alice", "id": "https://openalex.org/A1"}},
            ],
            "abstract_inverted_index": {"Hello": [0], "world": [1]},
            "referenced_works": ["https://openalex.org/W200"],
            "open_access": {"oa_url": "https://example.com/paper.pdf"},
            "concepts": [{"display_name": "Economics"}],
        }
        paper = OpenAlexClient._parse_work(work)

        assert paper.openalex_id == "W100"
        assert paper.doi == "10.1234/test"
        assert paper.title == "Test Paper"
        assert paper.publication_year == 2020
        assert paper.cited_by_count == 42
        assert paper.authors[0].name == "Alice"
        assert paper.authors[0].openalex_id == "A1"
        assert paper.abstract == "Hello world"
        assert paper.referenced_works == ["W200"]
        assert paper.open_access_url == "https://example.com/paper.pdf"
        assert paper.concepts == ["Economics"]

    def test_missing_optional_fields(self):
        work = {"id": "https://openalex.org/W999"}
        paper = OpenAlexClient._parse_work(work)

        assert paper.openalex_id == "W999"
        assert paper.doi == ""
        assert paper.title == ""
        assert paper.abstract == ""
        assert paper.open_access_url == ""


# ---------------------------------------------------------------------------
# OpenAlexClient — API mocking
# ---------------------------------------------------------------------------

def _mock_urlopen(response_bytes: bytes):
    """Return a mock that simulates urllib.request.urlopen."""
    mock_resp = MagicMock()
    mock_resp.read.return_value = response_bytes
    mock_resp.__enter__ = lambda s: s
    mock_resp.__exit__ = MagicMock(return_value=False)
    return mock_resp


def _make_api_response(results: list[dict], next_cursor: str | None = None) -> bytes:
    """Build a fake OpenAlex API response."""
    return json.dumps({
        "results": results,
        "meta": {"next_cursor": next_cursor, "count": len(results)},
    }).encode("utf-8")


_SAMPLE_WORK = {
    "id": "https://openalex.org/W100",
    "title": "Test Paper",
    "publication_year": 2020,
    "cited_by_count": 100,
    "authorships": [],
    "referenced_works": [],
    "concepts": [],
}


class TestOpenAlexClientFetch:
    @patch("leanknowledge.openalex.urllib.request.urlopen")
    def test_single_page_fetch(self, mock_open, tmp_path):
        mock_open.return_value = _mock_urlopen(
            _make_api_response([_SAMPLE_WORK], next_cursor=None)
        )
        client = OpenAlexClient(rate_limit=0.0)
        papers = client.fetch_papers(max_papers=10, output_dir=tmp_path)

        assert len(papers) == 1
        assert papers[0].openalex_id == "W100"
        assert (tmp_path / "papers.jsonl").exists()

    @patch("leanknowledge.openalex.urllib.request.urlopen")
    def test_multi_page_fetch(self, mock_open, tmp_path):
        """Two pages of results with cursor pagination."""
        work2 = {**_SAMPLE_WORK, "id": "https://openalex.org/W200", "title": "Second"}
        mock_open.side_effect = [
            _mock_urlopen(_make_api_response([_SAMPLE_WORK], next_cursor="cursor2")),
            _mock_urlopen(_make_api_response([work2], next_cursor=None)),
        ]
        client = OpenAlexClient(rate_limit=0.0)
        papers = client.fetch_papers(max_papers=10, output_dir=tmp_path)

        assert len(papers) == 2
        assert papers[1].openalex_id == "W200"

    @patch("leanknowledge.openalex.urllib.request.urlopen")
    def test_max_papers_limit(self, mock_open, tmp_path):
        """Stop after reaching max_papers even if more are available."""
        mock_open.return_value = _mock_urlopen(
            _make_api_response([_SAMPLE_WORK], next_cursor="more")
        )
        client = OpenAlexClient(rate_limit=0.0)
        papers = client.fetch_papers(max_papers=1, output_dir=tmp_path)

        assert len(papers) == 1

    @patch("leanknowledge.openalex.urllib.request.urlopen")
    def test_network_error_stops_gracefully(self, mock_open, tmp_path):
        import urllib.error
        mock_open.side_effect = urllib.error.URLError("connection refused")

        client = OpenAlexClient(rate_limit=0.0)
        papers = client.fetch_papers(max_papers=10, output_dir=tmp_path)

        assert papers == []


class TestFetchResumability:
    @patch("leanknowledge.openalex.urllib.request.urlopen")
    def test_resumes_from_state(self, mock_open, tmp_path):
        """If _fetch_state.json exists, resume from saved cursor."""
        # Pre-populate with one paper
        paper = Paper(openalex_id="W100", title="Already Fetched")
        jsonl_path = tmp_path / "papers.jsonl"
        save_papers_jsonl([paper], jsonl_path)

        state_path = tmp_path / "_fetch_state.json"
        state_path.write_text(
            json.dumps({"cursor": "saved_cursor", "count": 1}),
            encoding="utf-8",
        )

        # API returns one more paper
        work2 = {**_SAMPLE_WORK, "id": "https://openalex.org/W200", "title": "New"}
        mock_open.return_value = _mock_urlopen(
            _make_api_response([work2], next_cursor=None)
        )

        client = OpenAlexClient(rate_limit=0.0)
        papers = client.fetch_papers(max_papers=5, output_dir=tmp_path)

        assert len(papers) == 2
        assert papers[0].openalex_id == "W100"
        assert papers[1].openalex_id == "W200"

        # Check that cursor was used
        call_url = mock_open.call_args[0][0].full_url
        assert "saved_cursor" in call_url


# ---------------------------------------------------------------------------
# Graph persistence
# ---------------------------------------------------------------------------

class TestGraphPersistence:
    def test_save_load_roundtrip(self, tmp_path):
        from leanknowledge.openalex import load_graph, save_graph

        papers = [
            Paper(openalex_id="A", referenced_works=["B"]),
            Paper(openalex_id="B", referenced_works=[]),
        ]
        G = build_citation_graph(papers)
        path = tmp_path / "graph.json"
        save_graph(G, path)
        G2 = load_graph(path)

        assert set(G2.nodes) == {"A", "B"}
        assert G2.has_edge("A", "B")
        assert G2.number_of_edges() == 1
