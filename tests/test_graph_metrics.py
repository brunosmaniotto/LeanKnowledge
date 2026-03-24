"""Tests for graph_metrics module — fully self-contained with mock graphs."""

import pytest

from leanknowledge.dependency_graph import (
    DependencyGraph,
    GraphNode,
    GraphEdge,
    NodeType,
    EdgeType,
)
from leanknowledge.graph_metrics import (
    NodeImportance,
    DEFAULT_WEIGHTS,
    compute_importance,
    rank_nodes,
)


# ---------------------------------------------------------------------------
# Helpers
# ---------------------------------------------------------------------------

def _node(nid: str, ntype: NodeType = NodeType.DEFINITION) -> GraphNode:
    return GraphNode(item_id=nid, chapter=1, section="1.A",
                     node_type=ntype, statement=f"Statement for {nid}")


def _graph_with(nodes: list[str], edges: list[tuple[str, str]]) -> DependencyGraph:
    """Build a DependencyGraph from node IDs and (source, target) pairs."""
    g = DependencyGraph()
    for nid in nodes:
        g.nodes[nid] = _node(nid)
    for src, tgt in edges:
        g._add_edge(GraphEdge(src, tgt, EdgeType.NL_DEPENDENCY))
    return g


# ---------------------------------------------------------------------------
# Tests
# ---------------------------------------------------------------------------

class TestSingleNode:
    def test_single_node(self):
        g = _graph_with(["A"], [])
        imp = compute_importance(g)
        assert "A" in imp
        assert imp["A"].rank == 1
        assert imp["A"].composite == 0.0  # no edges → all metrics zero


class TestTwoNodes:
    def test_two_nodes_edge(self):
        g = _graph_with(["A", "B"], [("B", "A")])
        imp = compute_importance(g)
        # A is depended on by B → A should rank higher
        assert imp["A"].rank < imp["B"].rank
        assert imp["A"].in_degree == 1
        assert imp["B"].in_degree == 0


class TestChain:
    def test_chain_root_highest(self):
        """A ← B ← C ← D : A is the root, most depended-on."""
        g = _graph_with(["A", "B", "C", "D"],
                        [("B", "A"), ("C", "B"), ("D", "C")])
        imp = compute_importance(g)
        ranked = rank_nodes(imp, top_k=4)
        # A should have the most transitive dependents (B, C, D)
        assert imp["A"].transitive_dependents == 3
        assert imp["D"].transitive_dependents == 0
        # A should rank first
        assert ranked[0].node_id == "A"


class TestDisconnected:
    def test_disconnected_components(self):
        g = _graph_with(["A", "B", "C", "D"],
                        [("B", "A"), ("D", "C")])
        imp = compute_importance(g)
        # All 4 nodes present
        assert len(imp) == 4
        # Each root has 1 transitive dependent
        assert imp["A"].transitive_dependents == 1
        assert imp["C"].transitive_dependents == 1


class TestCustomWeights:
    def test_in_degree_only(self):
        """With only in_degree weight, highest in-degree node wins."""
        g = _graph_with(["A", "B", "C"],
                        [("B", "A"), ("C", "A")])
        weights = {"pagerank": 0.0, "transitive_dependents": 0.0,
                   "in_degree": 1.0, "betweenness": 0.0}
        imp = compute_importance(g, weights=weights)
        assert imp["A"].rank == 1
        assert imp["A"].composite == 1.0


class TestCompositeBounded:
    def test_composite_in_unit_interval(self):
        g = _graph_with(["A", "B", "C", "D", "E"],
                        [("B", "A"), ("C", "A"), ("D", "B"), ("E", "C")])
        imp = compute_importance(g)
        for ni in imp.values():
            assert 0.0 <= ni.composite <= 1.0


class TestRankOrdering:
    def test_ranks_unique_and_contiguous(self):
        g = _graph_with(["A", "B", "C", "D"],
                        [("B", "A"), ("C", "B"), ("D", "C")])
        imp = compute_importance(g)
        ranks = sorted(ni.rank for ni in imp.values())
        assert ranks == [1, 2, 3, 4]


class TestTopK:
    def test_top_k_limits_output(self):
        g = _graph_with(["A", "B", "C", "D", "E"],
                        [("B", "A"), ("C", "B"), ("D", "C"), ("E", "D")])
        imp = compute_importance(g)
        top2 = rank_nodes(imp, top_k=2)
        assert len(top2) == 2
        assert top2[0].rank == 1
        assert top2[1].rank == 2
