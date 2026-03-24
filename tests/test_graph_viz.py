"""Tests for graph_viz module — fully self-contained with mock graphs."""

import pytest

from rich.table import Table
from rich.tree import Tree

from leanknowledge.dependency_graph import (
    DependencyGraph,
    GraphNode,
    GraphEdge,
    NodeType,
    EdgeType,
    MathDomain,
)
from leanknowledge.graph_metrics import compute_importance
from leanknowledge.graph_viz import (
    render_metrics_table,
    render_tree,
    graph_to_html,
)


# ---------------------------------------------------------------------------
# Helpers
# ---------------------------------------------------------------------------

def _node(nid: str, ntype: NodeType = NodeType.DEFINITION,
          chapter: int = 1, section: str = "1.A",
          domain: MathDomain = MathDomain.GENERAL) -> GraphNode:
    return GraphNode(item_id=nid, chapter=chapter, section=section,
                     node_type=ntype, statement=f"Statement for {nid}",
                     domain=domain)


def _make_graph() -> DependencyGraph:
    """A small DAG: A ← B ← C, A ← D."""
    g = DependencyGraph()
    g.nodes["A"] = _node("A", NodeType.DEFINITION)
    g.nodes["B"] = _node("B", NodeType.THEOREM)
    g.nodes["C"] = _node("C", NodeType.THEOREM)
    g.nodes["D"] = _node("D", NodeType.EXAMPLE)
    g._add_edge(GraphEdge("B", "A", EdgeType.NL_DEPENDENCY))
    g._add_edge(GraphEdge("C", "B", EdgeType.NL_DEPENDENCY))
    g._add_edge(GraphEdge("D", "A", EdgeType.NL_DEPENDENCY))
    return g


# ---------------------------------------------------------------------------
# Tests: metrics table
# ---------------------------------------------------------------------------

class TestMetricsTable:
    def test_returns_table(self):
        g = _make_graph()
        imp = compute_importance(g)
        table = render_metrics_table(imp, top_k=4)
        assert isinstance(table, Table)

    def test_correct_columns(self):
        g = _make_graph()
        imp = compute_importance(g)
        table = render_metrics_table(imp, top_k=4)
        col_names = [c.header for c in table.columns]
        assert "Rank" in col_names
        assert "Node ID" in col_names
        assert "Composite" in col_names

    def test_row_count(self):
        g = _make_graph()
        imp = compute_importance(g)
        table = render_metrics_table(imp, top_k=2)
        assert table.row_count == 2


# ---------------------------------------------------------------------------
# Tests: tree modes
# ---------------------------------------------------------------------------

class TestTreeLayers:
    def test_layers_mode(self):
        g = _make_graph()
        imp = compute_importance(g)
        tree = render_tree(g, imp, mode="layers", top_n=5)
        assert isinstance(tree, Tree)
        assert "Dependency Layers" in tree.label.plain if hasattr(tree.label, 'plain') else "Dependency Layers" in str(tree.label)


class TestTreeDeps:
    def test_deps_mode(self):
        g = _make_graph()
        imp = compute_importance(g)
        tree = render_tree(g, imp, mode="deps", node_id="C", max_depth=3)
        assert isinstance(tree, Tree)

    def test_deps_requires_node_id(self):
        g = _make_graph()
        with pytest.raises(ValueError, match="node_id"):
            render_tree(g, None, mode="deps")


class TestTreeTop:
    def test_top_mode(self):
        g = _make_graph()
        imp = compute_importance(g)
        tree = render_tree(g, imp, mode="top", top_n=2)
        assert isinstance(tree, Tree)


# ---------------------------------------------------------------------------
# Tests: HTML output
# ---------------------------------------------------------------------------

class TestHTMLOutput:
    def test_contains_vis_cdn(self):
        g = _make_graph()
        html_str = graph_to_html(g)
        assert "vis-network@9.1.9" in html_str
        assert "vis-network.min.js" in html_str

    def test_contains_graph_data(self):
        g = _make_graph()
        html_str = graph_to_html(g)
        assert "GRAPH_DATA" in html_str
        # All node IDs should appear in the data
        for nid in g.nodes:
            assert nid in html_str

    def test_with_importance(self):
        g = _make_graph()
        imp = compute_importance(g)
        html_str = graph_to_html(g, importance=imp)
        assert "Rank" in html_str
        assert "Composite" in html_str
