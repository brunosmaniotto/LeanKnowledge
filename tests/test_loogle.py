"""Tests for the Loogle HTTP client and Loogle-based library backends."""

import json
import time
from unittest.mock import MagicMock, patch

import pytest

from leanknowledge.loogle import LoogleClient, LoogleResult


# ---------------------------------------------------------------------------
# Fixtures / helpers
# ---------------------------------------------------------------------------

def _make_response(hits: list[dict], error: str | None = None) -> bytes:
    """Build a fake Loogle JSON response body."""
    return json.dumps({"hits": hits, "error": error}).encode("utf-8")


_SAMPLE_HIT = {
    "name": "Nat.add_comm",
    "type": "\u2200 (n m : \u2115), n + m = m + n",
    "module": "Mathlib.Data.Nat.Basic",
    "doc": "Addition is commutative",
}

_SAMPLE_HIT_2 = {
    "name": "Nat.add_assoc",
    "type": "\u2200 (n m k : \u2115), n + m + k = n + (m + k)",
    "module": "Mathlib.Data.Nat.Basic",
    "doc": "Addition is associative",
}


def _mock_urlopen(response_bytes: bytes):
    """Return a mock that simulates urllib.request.urlopen."""
    mock_resp = MagicMock()
    mock_resp.read.return_value = response_bytes
    mock_resp.__enter__ = lambda s: s
    mock_resp.__exit__ = MagicMock(return_value=False)
    return mock_resp


# ---------------------------------------------------------------------------
# LoogleResult
# ---------------------------------------------------------------------------

class TestLoogleResult:
    def test_equality_by_name(self):
        a = LoogleResult(name="Nat.add_comm", type_sig="...", module="M")
        b = LoogleResult(name="Nat.add_comm", type_sig="different", module="X")
        assert a == b

    def test_inequality(self):
        a = LoogleResult(name="Nat.add_comm", type_sig="...", module="M")
        b = LoogleResult(name="Nat.add_assoc", type_sig="...", module="M")
        assert a != b

    def test_hashable(self):
        a = LoogleResult(name="Nat.add_comm", type_sig="...", module="M")
        b = LoogleResult(name="Nat.add_comm", type_sig="other", module="X")
        assert {a, b} == {a}


# ---------------------------------------------------------------------------
# LoogleClient — search result parsing
# ---------------------------------------------------------------------------

class TestLoogleSearch:
    @patch("leanknowledge.loogle.urllib.request.urlopen")
    def test_basic_search(self, mock_open):
        mock_open.return_value = _mock_urlopen(
            _make_response([_SAMPLE_HIT, _SAMPLE_HIT_2])
        )
        client = LoogleClient(rate_limit=0.0)
        results = client.search("Nat.add_comm")

        assert len(results) == 2
        assert results[0].name == "Nat.add_comm"
        assert results[0].type_sig == "\u2200 (n m : \u2115), n + m = m + n"
        assert results[0].module == "Mathlib.Data.Nat.Basic"
        assert results[0].doc == "Addition is commutative"

    @patch("leanknowledge.loogle.urllib.request.urlopen")
    def test_num_results_limit(self, mock_open):
        mock_open.return_value = _mock_urlopen(
            _make_response([_SAMPLE_HIT, _SAMPLE_HIT_2])
        )
        client = LoogleClient(rate_limit=0.0)
        results = client.search("Nat", num_results=1)
        assert len(results) == 1

    @patch("leanknowledge.loogle.urllib.request.urlopen")
    def test_search_by_type(self, mock_open):
        mock_open.return_value = _mock_urlopen(
            _make_response([_SAMPLE_HIT])
        )
        client = LoogleClient(rate_limit=0.0)
        results = client.search_by_type("\u2200 (a b : \u2115), a + b = b + a")
        assert len(results) == 1
        assert results[0].name == "Nat.add_comm"

    @patch("leanknowledge.loogle.urllib.request.urlopen")
    def test_empty_query_returns_empty(self, mock_open):
        client = LoogleClient(rate_limit=0.0)
        assert client.search("") == []
        assert client.search("   ") == []
        mock_open.assert_not_called()

    @patch("leanknowledge.loogle.urllib.request.urlopen")
    def test_empty_hits_returns_empty(self, mock_open):
        mock_open.return_value = _mock_urlopen(_make_response([]))
        client = LoogleClient(rate_limit=0.0)
        assert client.search("nonexistent") == []

    @patch("leanknowledge.loogle.urllib.request.urlopen")
    def test_missing_doc_field_defaults_empty(self, mock_open):
        hit = {"name": "Foo", "type": "Bar", "module": "M"}  # no "doc"
        mock_open.return_value = _mock_urlopen(_make_response([hit]))
        client = LoogleClient(rate_limit=0.0)
        results = client.search("Foo")
        assert results[0].doc == ""


# ---------------------------------------------------------------------------
# Error handling
# ---------------------------------------------------------------------------

class TestLoogleErrors:
    @patch("leanknowledge.loogle.urllib.request.urlopen")
    def test_network_error_returns_empty(self, mock_open):
        import urllib.error
        mock_open.side_effect = urllib.error.URLError("connection refused")
        client = LoogleClient(rate_limit=0.0)
        results = client.search("anything")
        assert results == []

    @patch("leanknowledge.loogle.urllib.request.urlopen")
    def test_timeout_returns_empty(self, mock_open):
        mock_open.side_effect = TimeoutError("timed out")
        client = LoogleClient(rate_limit=0.0)
        assert client.search("anything") == []

    @patch("leanknowledge.loogle.urllib.request.urlopen")
    def test_api_error_returns_empty(self, mock_open):
        """Loogle returns {"hits": [], "error": "some message"}."""
        mock_open.return_value = _mock_urlopen(
            _make_response([], error="invalid query syntax")
        )
        client = LoogleClient(rate_limit=0.0)
        assert client.search("bad query!!!") == []

    @patch("leanknowledge.loogle.urllib.request.urlopen")
    def test_invalid_json_returns_empty(self, mock_open):
        mock_resp = MagicMock()
        mock_resp.read.return_value = b"not json at all"
        mock_resp.__enter__ = lambda s: s
        mock_resp.__exit__ = MagicMock(return_value=False)
        mock_open.return_value = mock_resp
        client = LoogleClient(rate_limit=0.0)
        assert client.search("query") == []

    @patch("leanknowledge.loogle.urllib.request.urlopen")
    def test_http_error_returns_empty(self, mock_open):
        import urllib.error
        mock_open.side_effect = urllib.error.HTTPError(
            url="http://x", code=500, msg="err", hdrs=None, fp=None  # type: ignore[arg-type]
        )
        client = LoogleClient(rate_limit=0.0)
        assert client.search("query") == []


# ---------------------------------------------------------------------------
# Caching
# ---------------------------------------------------------------------------

class TestLoogleCaching:
    @patch("leanknowledge.loogle.urllib.request.urlopen")
    def test_same_query_cached(self, mock_open):
        """Second call for the same query should NOT hit the network."""
        mock_open.return_value = _mock_urlopen(
            _make_response([_SAMPLE_HIT])
        )
        client = LoogleClient(rate_limit=0.0)

        r1 = client.search("Nat.add_comm")
        r2 = client.search("Nat.add_comm")

        assert r1 == r2
        # urlopen should only have been called once
        assert mock_open.call_count == 1

    @patch("leanknowledge.loogle.urllib.request.urlopen")
    def test_different_queries_not_cached(self, mock_open):
        mock_open.return_value = _mock_urlopen(
            _make_response([_SAMPLE_HIT])
        )
        client = LoogleClient(rate_limit=0.0)

        client.search("Nat.add_comm")
        client.search("Nat.add_assoc")

        assert mock_open.call_count == 2

    @patch("leanknowledge.loogle.urllib.request.urlopen")
    def test_error_results_cached(self, mock_open):
        """Even failures are cached to avoid hammering a broken endpoint."""
        import urllib.error
        mock_open.side_effect = urllib.error.URLError("down")
        client = LoogleClient(rate_limit=0.0)

        r1 = client.search("something")
        r2 = client.search("something")

        assert r1 == r2 == []
        assert mock_open.call_count == 1  # second call used cache

    @patch("leanknowledge.loogle.urllib.request.urlopen")
    def test_clear_cache(self, mock_open):
        mock_open.return_value = _mock_urlopen(
            _make_response([_SAMPLE_HIT])
        )
        client = LoogleClient(rate_limit=0.0)

        client.search("Nat.add_comm")
        client.clear_cache()
        client.search("Nat.add_comm")

        assert mock_open.call_count == 2


# ---------------------------------------------------------------------------
# Rate limiting
# ---------------------------------------------------------------------------

class TestLoogleRateLimiting:
    @patch("leanknowledge.loogle.urllib.request.urlopen")
    def test_rate_limiting_enforced(self, mock_open):
        """Two rapid calls should be separated by at least rate_limit seconds."""
        mock_open.return_value = _mock_urlopen(
            _make_response([_SAMPLE_HIT])
        )
        client = LoogleClient(rate_limit=0.2)

        t0 = time.monotonic()
        client.search("query1")
        client.search("query2")  # should sleep ~0.2s
        elapsed = time.monotonic() - t0

        assert elapsed >= 0.15  # allow small margin

    @patch("leanknowledge.loogle.urllib.request.urlopen")
    def test_zero_rate_limit(self, mock_open):
        """rate_limit=0 should not add any delay."""
        mock_open.return_value = _mock_urlopen(
            _make_response([_SAMPLE_HIT])
        )
        client = LoogleClient(rate_limit=0.0)

        t0 = time.monotonic()
        client.search("q1")
        client.search("q2")
        elapsed = time.monotonic() - t0

        assert elapsed < 0.1  # should be near-instant
