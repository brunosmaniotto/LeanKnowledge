"""Tests for graph_blockers — blocker centrality recommender."""

import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent.parent / "src"))

from leanknowledge.graph_blockers import (
    BlockerInfo,
    compute_blocker_metrics,
    format_blocker_report,
    format_source_recommendations,
    _SOURCE_MAP,
)
from leanknowledge.dependency_graph import (
    DependencyGraph,
    GraphNode,
    GraphEdge,
    NodeType,
    EdgeType,
    MathDomain,
)


# ---------------------------------------------------------------------------
# Helpers
# ---------------------------------------------------------------------------

def _make_graph() -> DependencyGraph:
    """Build a small mock graph with 2 external blockers and 5 internal nodes."""
    g = DependencyGraph()

    # External blockers
    g.nodes["External:Kakutani_fixed_point_theorem"] = GraphNode(
        item_id="External:Kakutani_fixed_point_theorem",
        chapter=0, section="", node_type=NodeType.EXTERNAL,
        statement="Kakutani fixed point theorem",
    )
    g.nodes["External:Zorns_lemma"] = GraphNode(
        item_id="External:Zorns_lemma",
        chapter=0, section="", node_type=NodeType.EXTERNAL,
        statement="Zorn's lemma",
    )

    # Internal nodes across chapters
    for i, (nid, ch, dom) in enumerate([
        ("Theorem_1.A.1", 1, MathDomain.PREFERENCE_THEORY),
        ("Theorem_1.B.1", 1, MathDomain.PREFERENCE_THEORY),
        ("Proposition_2.C.1", 2, MathDomain.CONSUMER_DEMAND),
        ("Proposition_3.E.1", 3, MathDomain.EXPENDITURE_DUALITY),
        ("Definition_4.B.1", 4, MathDomain.WELFARE_AGGREGATION),
    ]):
        g.nodes[nid] = GraphNode(
            item_id=nid, chapter=ch, section=f"{ch}.{'ABCE'[i % 4]}",
            node_type=NodeType.THEOREM if "Theorem" in nid or "Prop" in nid else NodeType.DEFINITION,
            statement=f"Statement for {nid}", domain=dom,
        )

    # Edges: Kakutani blocks 3 items (one transitively via Theorem_1.A.1)
    g._add_edge(GraphEdge("Theorem_1.A.1", "External:Kakutani_fixed_point_theorem", EdgeType.CROSS_CHAPTER))
    g._add_edge(GraphEdge("Proposition_2.C.1", "External:Kakutani_fixed_point_theorem", EdgeType.CROSS_CHAPTER))
    g._add_edge(GraphEdge("Proposition_3.E.1", "Theorem_1.A.1", EdgeType.NL_DEPENDENCY))

    # Edges: Zorns_lemma blocks 1 item
    g._add_edge(GraphEdge("Definition_4.B.1", "External:Zorns_lemma", EdgeType.CROSS_CHAPTER))

    return g


# ---------------------------------------------------------------------------
# Tests
# ---------------------------------------------------------------------------

def test_single_external_blocker():
    """A graph with one external node computes blocking_power correctly."""
    g = DependencyGraph()
    g.nodes["External:foo"] = GraphNode(
        item_id="External:foo", chapter=0, section="",
        node_type=NodeType.EXTERNAL, statement="foo",
    )
    g.nodes["T1"] = GraphNode(
        item_id="T1", chapter=1, section="1.A",
        node_type=NodeType.THEOREM, statement="thm 1",
        domain=MathDomain.PREFERENCE_THEORY,
    )
    g._add_edge(GraphEdge("T1", "External:foo", EdgeType.CROSS_CHAPTER))

    blockers = compute_blocker_metrics(g)
    assert len(blockers) == 1
    b = blockers[0]
    assert b.blocker_id == "External:foo"
    assert b.direct_dependents == 1
    assert b.transitive_dependents == 1
    assert b.rank == 1
    assert b.blocking_power > 0


def test_multiple_externals_ranked_by_score():
    """Multiple externals are ranked by composite blocking power."""
    g = _make_graph()
    blockers = compute_blocker_metrics(g)

    assert len(blockers) == 2
    # Kakutani should rank higher (3 total dependents vs 1)
    kakutani = blockers[0]
    zorns = blockers[1]
    assert "Kakutani" in kakutani.blocker_id
    assert "Zorns" in zorns.blocker_id
    assert kakutani.blocking_power >= zorns.blocking_power
    assert kakutani.rank == 1
    assert zorns.rank == 2


def test_chapter_reach():
    """chapters_affected includes all chapters with transitive dependents."""
    g = _make_graph()
    blockers = compute_blocker_metrics(g)
    kakutani = [b for b in blockers if "Kakutani" in b.blocker_id][0]
    # Direct: ch1 (Theorem_1.A.1), ch2 (Proposition_2.C.1)
    # Transitive: ch3 (Proposition_3.E.1 depends on Theorem_1.A.1)
    assert 1 in kakutani.chapters_affected
    assert 2 in kakutani.chapters_affected
    assert 3 in kakutani.chapters_affected


def test_transitive_dependents():
    """Transitive dependents count includes indirect dependents."""
    g = _make_graph()
    blockers = compute_blocker_metrics(g)
    kakutani = [b for b in blockers if "Kakutani" in b.blocker_id][0]
    # Direct: Theorem_1.A.1, Proposition_2.C.1
    assert kakutani.direct_dependents == 2
    # Transitive: above + Proposition_3.E.1
    assert kakutani.transitive_dependents == 3


def test_source_mapping_known():
    """Known External: names get correct category and source."""
    g = _make_graph()
    blockers = compute_blocker_metrics(g)
    kakutani = [b for b in blockers if "Kakutani" in b.blocker_id][0]
    assert kakutani.category == "textbook"
    assert "Aliprantis" in kakutani.suggested_source

    zorns = [b for b in blockers if "Zorns" in b.blocker_id][0]
    assert zorns.category == "mathlib"
    assert "Zorn" in zorns.suggested_source


def test_source_mapping_unknown():
    """Unknown External: names get 'unknown' category."""
    g = DependencyGraph()
    g.nodes["External:obscure_thing"] = GraphNode(
        item_id="External:obscure_thing", chapter=0, section="",
        node_type=NodeType.EXTERNAL, statement="obscure",
    )
    g.nodes["T1"] = GraphNode(
        item_id="T1", chapter=1, section="1.A",
        node_type=NodeType.THEOREM, statement="thm",
    )
    g._add_edge(GraphEdge("T1", "External:obscure_thing", EdgeType.CROSS_CHAPTER))

    blockers = compute_blocker_metrics(g)
    assert blockers[0].category == "unknown"
    assert blockers[0].suggested_source == ""


def test_no_external_nodes():
    """Graph with no external nodes returns empty list."""
    g = DependencyGraph()
    g.nodes["T1"] = GraphNode(
        item_id="T1", chapter=1, section="1.A",
        node_type=NodeType.THEOREM, statement="thm",
    )
    assert compute_blocker_metrics(g) == []


def test_format_blocker_report():
    """Report renders without errors and includes key information."""
    g = _make_graph()
    blockers = compute_blocker_metrics(g)
    report = format_blocker_report(blockers, top_k=5)
    assert "Top-2 External Blockers" in report
    assert "Kakutani" in report
    assert "Zorns" in report
    assert "Total external blockers: 2" in report
    assert "By category:" in report


def test_format_source_recommendations():
    """Source recommendations group by source and show impact."""
    g = _make_graph()
    blockers = compute_blocker_metrics(g)
    recs = format_source_recommendations(blockers)
    assert "Source Recommendations" in recs
    assert "textbook" in recs
    assert "mathlib" in recs
    assert "Kakutani" in recs


def test_domains_affected():
    """domains_affected includes domains of all transitive dependents."""
    g = _make_graph()
    blockers = compute_blocker_metrics(g)
    kakutani = [b for b in blockers if "Kakutani" in b.blocker_id][0]
    # Dependents span preference_theory, consumer_demand, expenditure_duality
    assert len(kakutani.domains_affected) >= 2


def test_source_map_has_entries():
    """Sanity check that the source map is populated."""
    assert len(_SOURCE_MAP) > 20
    assert "Kakutani_fixed_point_theorem" in _SOURCE_MAP
    assert "Zorns_lemma" in _SOURCE_MAP
