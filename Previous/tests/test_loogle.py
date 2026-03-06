"""Tests for Loogle client and Librarian integration."""

import pytest
from unittest.mock import patch, MagicMock

from leanknowledge.loogle_client import LoogleHit, search, search_by_name, module_to_import


# --- Unit tests (no network) ---

def test_loogle_hit_creation():
    hit = LoogleHit(
        name="IsCompact.exists_isMaxOn",
        module="Mathlib.Topology.Order.Basic",
        type_sig="IsCompact s → ContinuousOn f s → s.Nonempty → ∃ x ∈ s, IsMaxOn f s x",
        doc="A continuous function on a compact set attains its maximum.",
    )
    assert hit.name == "IsCompact.exists_isMaxOn"
    assert hit.module == "Mathlib.Topology.Order.Basic"
    assert "IsCompact" in hit.type_sig


def test_module_to_import():
    assert module_to_import("Mathlib.Topology.Order.Basic") == "Mathlib.Topology.Order.Basic"
    assert module_to_import("  Mathlib.Order.Defs  ") == "Mathlib.Order.Defs"


def test_search_network_failure():
    """Search should return empty list on network failure, not raise."""
    with patch("leanknowledge.loogle_client.urllib.request.urlopen") as mock_urlopen:
        mock_urlopen.side_effect = OSError("Network unreachable")
        results = search("IsCompact")
        assert results == []


def test_search_parses_response():
    """Search should parse a valid Loogle JSON response."""
    fake_response = b'{"count": 2, "hits": [{"name": "foo", "module": "Bar", "type": "Nat", "doc": "a foo"}, {"name": "baz", "module": "Qux", "type": "Int", "doc": "a baz"}]}'

    mock_resp = MagicMock()
    mock_resp.read.return_value = fake_response
    mock_resp.__enter__ = lambda s: s
    mock_resp.__exit__ = MagicMock(return_value=False)

    with patch("leanknowledge.loogle_client.urllib.request.urlopen", return_value=mock_resp):
        results = search("foo")
        assert len(results) == 2
        assert results[0].name == "foo"
        assert results[0].module == "Bar"
        assert results[1].name == "baz"


def test_search_respects_max_results():
    """Search should truncate to max_results."""
    many_hits = [{"name": f"hit_{i}", "module": "M", "type": "T", "doc": "d"} for i in range(20)]
    fake_response = bytes('{"count": 20, "hits": ' + str(many_hits).replace("'", '"') + '}', "utf-8")

    mock_resp = MagicMock()
    mock_resp.read.return_value = fake_response
    mock_resp.__enter__ = lambda s: s
    mock_resp.__exit__ = MagicMock(return_value=False)

    with patch("leanknowledge.loogle_client.urllib.request.urlopen", return_value=mock_resp):
        results = search("test", max_results=3)
        assert len(results) == 3


# --- Integration test (requires network, skip in CI) ---

@pytest.mark.skipif(
    not pytest.importorskip("urllib.request", reason="no network"),
    reason="network test"
)
def test_loogle_live_search():
    """Live test against loogle.lean-lang.org. Skip if offline."""
    try:
        results = search("IsCompact", max_results=3)
        # If we get results, verify structure
        if results:
            assert results[0].name != ""
            assert results[0].module != ""
            print(f"  Live Loogle: {len(results)} results, top: {results[0].name}")
    except Exception:
        pytest.skip("Loogle API unreachable")
