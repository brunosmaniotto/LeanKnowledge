"""Tests for dependency_graph module — fully self-contained with mock data."""

import json
import tempfile
from pathlib import Path

import pytest

from leanknowledge.dependency_graph import (
    DependencyGraph,
    GraphNode,
    GraphEdge,
    ConceptCluster,
    NodeType,
    EdgeType,
    MathDomain,
    build_graph,
    _extract_axiom_declarations,
)


# ---------------------------------------------------------------------------
# Helpers to create mock chapter data
# ---------------------------------------------------------------------------

def _make_chapter_dir(tmp: Path, chapter_num: int, items: list[dict],
                      rosetta: list[dict] | None = None,
                      lean_files: dict[str, str] | None = None) -> Path:
    """Create a mock chapter directory with extraction.json, rosetta, and lean files."""
    ch_dir = tmp / f"mwg_ch{chapter_num}"
    ch_dir.mkdir(parents=True)

    # extraction.json
    extraction = {"source": f"MWG Ch{chapter_num}", "items": items}
    (ch_dir / "extraction.json").write_text(json.dumps(extraction), encoding="utf-8")

    # rosetta_stone.jsonl
    if rosetta:
        lines = [json.dumps(r) for r in rosetta]
        (ch_dir / "rosetta_stone.jsonl").write_text("\n".join(lines), encoding="utf-8")

    # lean files
    if lean_files:
        lean_dir = ch_dir / "lean"
        lean_dir.mkdir()
        for name, code in lean_files.items():
            (lean_dir / name).write_text(code, encoding="utf-8")

    return ch_dir


def _item(id: str, type: str = "claim", section: str = "1.A",
          deps: list[str] | None = None, statement: str = "") -> dict:
    return {
        "id": id,
        "type": type,
        "role": "definition" if type == "definition" else "claimed_result",
        "statement": statement or f"Statement for {id}",
        "dependencies": deps or [],
        "section": section,
    }


# ---------------------------------------------------------------------------
# Tests
# ---------------------------------------------------------------------------

class TestLoadChapter:
    def test_nodes_created(self, tmp_path):
        items = [
            _item("Def_1", "definition", "1.B", statement="The preference relation is rational"),
            _item("Claim_1", "claim", "1.B", deps=["Def_1"]),
            _item("Prop_1", "proposition", "1.C", deps=["Def_1", "Claim_1"]),
        ]
        ch_dir = _make_chapter_dir(tmp_path, 1, items)

        g = DependencyGraph()
        added = g.load_chapter(ch_dir, 1)

        assert added == 3
        assert "Def_1" in g.nodes
        assert g.nodes["Def_1"].node_type == NodeType.DEFINITION
        assert g.nodes["Claim_1"].node_type == NodeType.THEOREM
        assert g.nodes["Prop_1"].node_type == NodeType.THEOREM

    def test_nl_edges_created(self, tmp_path):
        items = [
            _item("Def_1", "definition", "1.B"),
            _item("Claim_1", "claim", "1.B", deps=["Def_1"]),
        ]
        ch_dir = _make_chapter_dir(tmp_path, 1, items)

        g = DependencyGraph()
        g.load_chapter(ch_dir, 1)

        assert len(g.edges) == 1
        assert g.edges[0].source_id == "Claim_1"
        assert g.edges[0].target_id == "Def_1"
        assert g.edges[0].edge_type == EdgeType.NL_DEPENDENCY

    def test_rosetta_enrichment(self, tmp_path):
        items = [_item("Claim_1", "claim", "1.B")]
        rosetta = [{"id": "Claim_1", "lean_code": "import Mathlib\ntheorem ...", "attempts": 7,
                     "mathlib_identifiers": ["Function.invFun"]}]
        ch_dir = _make_chapter_dir(tmp_path, 1, items, rosetta=rosetta)

        g = DependencyGraph()
        g.load_chapter(ch_dir, 1)

        assert g.nodes["Claim_1"].attempts == 7
        assert g.nodes["Claim_1"].proof_difficulty == "hard"
        assert g.nodes["Claim_1"].mathlib_deps == ["Function.invFun"]

    def test_lean_enrichment(self, tmp_path):
        items = [_item("Claim_1", "claim", "1.B")]
        lean_code = "import Mathlib\n\ntheorem foo : True := by\n  simp\n  linarith\n"
        ch_dir = _make_chapter_dir(tmp_path, 1, items, lean_files={"claim_1.lean": lean_code})

        g = DependencyGraph()
        g.load_chapter(ch_dir, 1)

        assert "simp" in g.nodes["Claim_1"].tactics_used
        assert "linarith" in g.nodes["Claim_1"].tactics_used

    def test_axiom_detection(self, tmp_path):
        items = [_item("Claim_1", "claim", "1.B")]
        lean_code = (
            "import Mathlib\n\n"
            "axiom MWG.rational_pref (X : Type) : Prop\n\n"
            "theorem foo : True := by trivial\n"
        )
        ch_dir = _make_chapter_dir(tmp_path, 1, items, lean_files={"claim_1.lean": lean_code})

        g = DependencyGraph()
        g.load_chapter(ch_dir, 1)

        assert "MWG.rational_pref" in g.nodes["Claim_1"].axioms_declared
        # Should have an AXIOMATIZES edge
        ax_edges = [e for e in g.edges if e.edge_type == EdgeType.AXIOMATIZES]
        assert len(ax_edges) == 1
        assert ax_edges[0].target_id == "MWG.rational_pref"


class TestCrossChapterResolution:
    def test_resolves_external_refs(self, tmp_path):
        ch1_items = [
            _item("Definition_1.B.1", "definition", "1.B",
                  statement="The preference relation is rational"),
        ]
        ch2_items = [
            _item("Claim_2C_a", "claim", "2.C", deps=["External:rational_preferences"]),
        ]
        ch1_dir = _make_chapter_dir(tmp_path, 1, ch1_items)
        ch2_dir = _make_chapter_dir(tmp_path, 2, ch2_items)

        g = DependencyGraph()
        g.load_chapter(ch1_dir, 1)
        g.load_chapter(ch2_dir, 2)
        resolved = g.resolve_cross_chapter_refs()

        assert resolved == 1
        cross_edges = [e for e in g.edges if e.edge_type == EdgeType.CROSS_CHAPTER]
        assert len(cross_edges) == 1
        assert cross_edges[0].source_id == "Claim_2C_a"
        assert cross_edges[0].target_id == "Definition_1.B.1"

    def test_math_external_creates_node(self, tmp_path):
        items = [
            _item("Claim_3X", "claim", "3.D", deps=["External:Weierstrass_extreme_value_theorem"]),
        ]
        ch_dir = _make_chapter_dir(tmp_path, 3, items)

        g = DependencyGraph()
        g.load_chapter(ch_dir, 3)
        resolved = g.resolve_cross_chapter_refs()

        assert resolved == 1
        assert "External:Weierstrass_extreme_value_theorem" in g.nodes
        ext_node = g.nodes["External:Weierstrass_extreme_value_theorem"]
        assert ext_node.node_type == NodeType.EXTERNAL
        assert ext_node.chapter == 0


class TestTopologicalOrder:
    def test_valid_ordering(self, tmp_path):
        items = [
            _item("A", "definition", "1.A"),
            _item("B", "claim", "1.A", deps=["A"]),
            _item("C", "claim", "1.A", deps=["B"]),
            _item("D", "claim", "1.A", deps=["A", "B"]),
        ]
        ch_dir = _make_chapter_dir(tmp_path, 1, items)

        g = DependencyGraph()
        g.load_chapter(ch_dir, 1)
        order = g.topological_order()

        # A must come before B, B before C and D
        pos = {nid: i for i, nid in enumerate(order)}
        assert pos["A"] < pos["B"]
        assert pos["B"] < pos["C"]
        assert pos["A"] < pos["D"]
        assert pos["B"] < pos["D"]

    def test_disconnected_nodes_included(self, tmp_path):
        items = [
            _item("A", "definition", "1.A"),
            _item("B", "definition", "1.B"),  # no deps
        ]
        ch_dir = _make_chapter_dir(tmp_path, 1, items)

        g = DependencyGraph()
        g.load_chapter(ch_dir, 1)
        order = g.topological_order()

        assert set(order) == {"A", "B"}


class TestTransitiveDependencies:
    def test_transitive_chain(self, tmp_path):
        items = [
            _item("A", "definition", "1.A"),
            _item("B", "claim", "1.A", deps=["A"]),
            _item("C", "claim", "1.A", deps=["B"]),
            _item("D", "claim", "1.A", deps=["C"]),
        ]
        ch_dir = _make_chapter_dir(tmp_path, 1, items)

        g = DependencyGraph()
        g.load_chapter(ch_dir, 1)

        # Direct deps of D
        assert g.dependencies_of("D") == ["C"]
        # Transitive deps of D
        transitive = g.dependencies_of("D", transitive=True)
        assert set(transitive) == {"A", "B", "C"}

    def test_transitive_dependents(self, tmp_path):
        items = [
            _item("A", "definition", "1.A"),
            _item("B", "claim", "1.A", deps=["A"]),
            _item("C", "claim", "1.A", deps=["A"]),
        ]
        ch_dir = _make_chapter_dir(tmp_path, 1, items)

        g = DependencyGraph()
        g.load_chapter(ch_dir, 1)

        dependents = g.dependents_of("A")
        assert set(dependents) == {"B", "C"}


class TestConceptClustering:
    def test_duplicate_definitions_grouped(self, tmp_path):
        ch1_items = [
            _item("Def_1B1", "definition", "1.B",
                  statement="The preference relation is rational if it is complete and transitive"),
        ]
        ch3_items = [
            _item("Def_3B1", "definition", "3.B",
                  statement="The preference relation is rational if it possesses completeness and transitivity"),
        ]
        ch1_dir = _make_chapter_dir(tmp_path, 1, ch1_items)
        ch3_dir = _make_chapter_dir(tmp_path, 3, ch3_items)

        g = DependencyGraph()
        g.load_chapter(ch1_dir, 1)
        g.load_chapter(ch3_dir, 3)

        clusters = g.infer_concept_clusters()
        # Both define "preference relation" concept
        matched = [c for c in clusters if "Def_1B1" in [c.canonical_id] + c.aliases
                   and "Def_3B1" in [c.canonical_id] + c.aliases]
        assert len(matched) == 1


class TestDomainClassification:
    def test_section_based_domains(self, tmp_path):
        items = [
            _item("D1", "definition", "1.B"),
            _item("D2", "definition", "2.E"),
            _item("D3", "definition", "3.E"),
            _item("D4", "definition", "4.D"),
        ]
        ch_dir = _make_chapter_dir(tmp_path, 1, items)

        g = DependencyGraph()
        g.load_chapter(ch_dir, 1)
        g.classify_domains()

        assert g.nodes["D1"].domain == MathDomain.PREFERENCE_THEORY
        assert g.nodes["D2"].domain == MathDomain.CONSUMER_DEMAND
        assert g.nodes["D3"].domain == MathDomain.EXPENDITURE_DUALITY
        assert g.nodes["D4"].domain == MathDomain.WELFARE_AGGREGATION

    def test_items_by_domain(self, tmp_path):
        items = [
            _item("D1", "definition", "1.B"),
            _item("D2", "definition", "1.B"),
            _item("D3", "definition", "2.E"),
        ]
        ch_dir = _make_chapter_dir(tmp_path, 1, items)

        g = DependencyGraph()
        g.load_chapter(ch_dir, 1)
        g.classify_domains()

        pref_items = g.items_by_domain(MathDomain.PREFERENCE_THEORY)
        assert len(pref_items) == 2


class TestSaveLoadRoundtrip:
    def test_roundtrip(self, tmp_path):
        items = [
            _item("Def_1", "definition", "1.B", statement="The preference relation is rational"),
            _item("Claim_1", "claim", "1.B", deps=["Def_1"]),
        ]
        ch_dir = _make_chapter_dir(tmp_path, 1, items)

        g = DependencyGraph()
        g.load_chapter(ch_dir, 1)
        g.classify_domains()

        save_path = tmp_path / "graph.json"
        g.save(save_path)

        g2 = DependencyGraph.load(save_path)

        assert set(g2.nodes.keys()) == set(g.nodes.keys())
        assert len(g2.edges) == len(g.edges)
        assert g2.nodes["Def_1"].node_type == NodeType.DEFINITION
        assert g2.nodes["Def_1"].domain == MathDomain.PREFERENCE_THEORY


class TestNoCycles:
    def test_simple_dag(self, tmp_path):
        items = [
            _item("A", "definition", "1.A"),
            _item("B", "claim", "1.A", deps=["A"]),
            _item("C", "claim", "1.A", deps=["B"]),
        ]
        ch_dir = _make_chapter_dir(tmp_path, 1, items)

        g = DependencyGraph()
        g.load_chapter(ch_dir, 1)

        assert not g.has_cycles()

    def test_detects_cycle(self, tmp_path):
        # Manually create a cycle by adding edges
        g = DependencyGraph()
        g.nodes["A"] = GraphNode(item_id="A", chapter=1, section="1.A",
                                  node_type=NodeType.DEFINITION, statement="A")
        g.nodes["B"] = GraphNode(item_id="B", chapter=1, section="1.A",
                                  node_type=NodeType.THEOREM, statement="B")
        g._add_edge(GraphEdge("A", "B", EdgeType.NL_DEPENDENCY))
        g._add_edge(GraphEdge("B", "A", EdgeType.NL_DEPENDENCY))

        assert g.has_cycles()


class TestDotOutput:
    def test_generates_valid_dot(self, tmp_path):
        items = [
            _item("Def_1", "definition", "1.B"),
            _item("Claim_1", "claim", "1.B", deps=["Def_1"]),
        ]
        ch_dir = _make_chapter_dir(tmp_path, 1, items)

        g = DependencyGraph()
        g.load_chapter(ch_dir, 1)
        g.classify_domains()

        dot = g.to_dot()
        assert "digraph MWG" in dot
        assert "Def_1" in dot
        assert "Claim_1" in dot
        assert "->" in dot

    def test_filter_chapter(self, tmp_path):
        ch1_items = [_item("Def_1", "definition", "1.B")]
        ch2_items = [_item("Def_2", "definition", "2.D")]
        ch1_dir = _make_chapter_dir(tmp_path, 1, ch1_items)
        ch2_dir = _make_chapter_dir(tmp_path, 2, ch2_items)

        g = DependencyGraph()
        g.load_chapter(ch1_dir, 1)
        g.load_chapter(ch2_dir, 2)

        dot = g.to_dot(filter_chapter=1)
        assert "Def_1" in dot
        assert "Def_2" not in dot


class TestBuildGraph:
    def test_convenience_builder(self, tmp_path):
        ch1_items = [
            _item("Definition_1.B.1", "definition", "1.B",
                  statement="The preference relation is rational"),
            _item("Claim_1", "claim", "1.B", deps=["Definition_1.B.1"]),
        ]
        ch2_items = [
            _item("Claim_2", "claim", "2.D", deps=["External:rational_preferences"]),
        ]
        ch1_dir = _make_chapter_dir(tmp_path, 1, ch1_items)
        ch2_dir = _make_chapter_dir(tmp_path, 2, ch2_items)

        g = build_graph([(ch1_dir, 1), (ch2_dir, 2)])

        assert len(g.nodes) == 3
        # Cross-chapter edge should be resolved (rational_preferences → Definition_1.B.1)
        cross = [e for e in g.edges if e.edge_type == EdgeType.CROSS_CHAPTER]
        assert len(cross) == 1
        assert cross[0].target_id == "Definition_1.B.1"
        # Domain should be classified
        assert g.nodes["Definition_1.B.1"].domain == MathDomain.PREFERENCE_THEORY


class TestAxiomExtraction:
    def test_extract_axiom_declarations(self):
        code = """
import Mathlib

axiom MWG.rational_pref (X : Type) : Prop
axiom MWG.completeness {X : Type} (R : X -> X -> Prop) : Prop

theorem foo : True := by trivial
"""
        axioms = _extract_axiom_declarations(code)
        assert axioms == ["MWG.rational_pref", "MWG.completeness"]

    def test_no_axioms(self):
        code = "import Mathlib\ntheorem foo : True := by trivial"
        assert _extract_axiom_declarations(code) == []


class TestSummary:
    def test_summary_output(self, tmp_path):
        items = [
            _item("Def_1", "definition", "1.B"),
            _item("Claim_1", "claim", "1.B", deps=["Def_1"]),
        ]
        ch_dir = _make_chapter_dir(tmp_path, 1, items)

        g = DependencyGraph()
        g.load_chapter(ch_dir, 1)
        g.classify_domains()

        s = g.summary()
        assert "Nodes: 2" in s
        assert "Edges: 1" in s
        assert "definition: 1" in s
