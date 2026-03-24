"""Dependency graph for MWG formalization — read-only analysis over extraction data.

Builds a directed graph of dependencies between extracted items (definitions,
theorems, propositions, examples) across chapters.  Three data sources:

1. extraction.json — NL-level dependencies (item ID references)
2. rosetta_stone.jsonl — Lean-level enrichment (attempts, mathlib identifiers)
3. lean/*.lean — ground truth: axiom declarations, tactics used
"""

import json
import re
from dataclasses import dataclass, field, asdict
from enum import Enum
from pathlib import Path

try:
    from .knowledge_graph import _extract_tactics, _extract_lean_deps
except ImportError:
    # knowledge_graph.py not yet created — provide no-op fallbacks
    def _extract_tactics(code: str) -> list[str]:  # type: ignore[misc]
        return []
    def _extract_lean_deps(code: str) -> list[str]:  # type: ignore[misc]
        return []


# ---------------------------------------------------------------------------
# Enums
# ---------------------------------------------------------------------------

class NodeType(str, Enum):
    DEFINITION = "definition"
    THEOREM = "theorem"
    AXIOM = "axiom"
    EXAMPLE = "example"
    EXTERNAL = "external"


class EdgeType(str, Enum):
    NL_DEPENDENCY = "nl_dependency"       # from extraction.json dependencies
    PROOF_USES = "proof_uses"             # from Lean code analysis
    AXIOMATIZES = "axiomatizes"           # item uses an axiom stub
    CROSS_CHAPTER = "cross_chapter"       # resolved External: ref
    MATHLIB = "mathlib"                   # references a Mathlib declaration


class MathDomain(str, Enum):
    PREFERENCE_THEORY = "preference_theory"
    CHOICE_THEORY = "choice_theory"
    CONSUMER_DEMAND = "consumer_demand"
    UTILITY_THEORY = "utility_theory"
    EXPENDITURE_DUALITY = "expenditure_duality"
    REVEALED_PREFERENCE = "revealed_preference"
    WELFARE_AGGREGATION = "welfare_aggregation"
    COMPARATIVE_STATICS = "comparative_statics"
    GENERAL = "general"


# Section → domain mapping for chapters 1-4
_SECTION_DOMAIN: dict[str, MathDomain] = {
    # Chapter 1
    "1.A": MathDomain.PREFERENCE_THEORY,
    "1.B": MathDomain.PREFERENCE_THEORY,
    "1.C": MathDomain.CHOICE_THEORY,
    "1.D": MathDomain.CHOICE_THEORY,
    # Chapter 2
    "2.B": MathDomain.CONSUMER_DEMAND,
    "2.C": MathDomain.CONSUMER_DEMAND,
    "2.D": MathDomain.CONSUMER_DEMAND,
    "2.E": MathDomain.CONSUMER_DEMAND,
    "2.F": MathDomain.REVEALED_PREFERENCE,
    # Chapter 3
    "3.B": MathDomain.PREFERENCE_THEORY,
    "3.C": MathDomain.UTILITY_THEORY,
    "3.D": MathDomain.UTILITY_THEORY,
    "3.E": MathDomain.EXPENDITURE_DUALITY,
    "3.F": MathDomain.EXPENDITURE_DUALITY,
    "3.G": MathDomain.COMPARATIVE_STATICS,
    "3.H": MathDomain.COMPARATIVE_STATICS,
    "3.I": MathDomain.WELFARE_AGGREGATION,
    "3.J": MathDomain.REVEALED_PREFERENCE,
    "3.AA": MathDomain.UTILITY_THEORY,
    # Chapter 4
    "4.B": MathDomain.WELFARE_AGGREGATION,
    "4.C": MathDomain.REVEALED_PREFERENCE,
    "4.D": MathDomain.WELFARE_AGGREGATION,
}

# Hand-curated seed table: External:name → item_id that defines the concept.
# Pure math results (Weierstrass, Kuhn-Tucker, etc.) stay as EXTERNAL nodes.
_EXTERNAL_SEED: dict[str, str] = {
    # Ch1 concepts
    "rational_preferences": "Definition_1.B.1",
    "rational_preference_relation": "Definition_1.B.1",
    "preference_relation": "Implicit_Def_1B_a",
    "weak_axiom_Section_1C": "Definition_1.C.1",
    "weak_axiom_revealed_preference": "Definition_1.C.1",
    # Ch2 concepts
    "consumption_set": "Implicit_Def_2C_a",
    "convex_set": "Implicit_Def_2C_b",
    "Walrasian_demand": "Implicit_Def_2E_a",
    "homogeneity_degree_zero": "Definition_2.E.1",
    "Walras_law": "Definition_2.E.2",
    "Slutsky_matrix": "Implicit_Def_2F_b",
    "Slutsky_equation": "Implicit_Def_2F_b",
    "Proposition_2F1": "Proposition_2.F.1",
    "strong_axiom": "Definition_3.J.1",
    # Ch3 concepts
    "utility_representation": "Definition_1.B.2",
    "expenditure_function": "Implicit_Def_3.E.b",
    "indirect_utility_function": "Implicit_Def_3.D.d",
    "Roys_identity": "Proposition_3.G.4",
    "homothetic_preferences": "Definition_3.B.6",
    "quasilinear_preferences": "Definition_3.B.7",
    "concave_utility": "Implicit_Def_3.B.b",
}

# External refs that are pure math theorems — no MWG item to resolve to
_MATH_EXTERNALS = {
    "Weierstrass_extreme_value_theorem",
    "Zorns_lemma",
    "Kuhn_Tucker_theorem",
    "Kuhn_Tucker_sufficiency",
    "Frobenius_theorem",
    "implicit_function_theorem",
    "separating_hyperplane_theorem",
    "envelope_theorem",
    "Gorman_form",
    "second_welfare_theorem",
    "integrability",
}


# ---------------------------------------------------------------------------
# Data classes
# ---------------------------------------------------------------------------

@dataclass
class GraphNode:
    item_id: str
    chapter: int
    section: str
    node_type: NodeType
    statement: str
    lean_file: str | None = None
    domain: MathDomain = MathDomain.GENERAL
    mathlib_deps: list[str] = field(default_factory=list)
    tactics_used: list[str] = field(default_factory=list)
    axioms_declared: list[str] = field(default_factory=list)
    attempts: int = 0
    proof_difficulty: str = "unknown"


@dataclass
class GraphEdge:
    source_id: str
    target_id: str
    edge_type: EdgeType
    confidence: float = 1.0


@dataclass
class ConceptCluster:
    canonical_id: str
    aliases: list[str] = field(default_factory=list)
    external_refs: list[str] = field(default_factory=list)


# ---------------------------------------------------------------------------
# Statement type → NodeType mapping
# ---------------------------------------------------------------------------

_TYPE_MAP: dict[str, NodeType] = {
    "definition": NodeType.DEFINITION,
    "axiom": NodeType.AXIOM,
    "proposition": NodeType.THEOREM,
    "theorem": NodeType.THEOREM,
    "lemma": NodeType.THEOREM,
    "corollary": NodeType.THEOREM,
    "claim": NodeType.THEOREM,
    "example": NodeType.EXAMPLE,
    "remark": NodeType.THEOREM,
    "invoked_dependency": NodeType.EXTERNAL,
    "implicit_assumption": NodeType.DEFINITION,
}


# ---------------------------------------------------------------------------
# Lean file analysis helpers
# ---------------------------------------------------------------------------

_AXIOM_RE = re.compile(r"^\s*axiom\s+([\w.]+)", re.MULTILINE)


def _extract_axiom_declarations(lean_code: str) -> list[str]:
    """Extract axiom names declared in Lean code."""
    return [m.group(1) for m in _AXIOM_RE.finditer(lean_code)]


def _find_lean_file(lean_dir: Path, item_id: str) -> Path | None:
    """Find the .lean file corresponding to an item ID."""
    # Normalize: lower-case, replace dots/spaces with underscores
    normalized = item_id.lower().replace(".", "_").replace(" ", "_")
    candidate = lean_dir / f"{normalized}.lean"
    if candidate.exists():
        return candidate
    # Try without leading type prefix (e.g., "claim_1b_a" from "Claim_1B_a")
    for f in lean_dir.iterdir():
        if f.suffix == ".lean" and f.stem.lower() == normalized:
            return f
    return None


# ---------------------------------------------------------------------------
# DependencyGraph
# ---------------------------------------------------------------------------

class DependencyGraph:
    """Dependency graph over MWG extracted items."""

    def __init__(self) -> None:
        self.nodes: dict[str, GraphNode] = {}
        self.edges: list[GraphEdge] = []
        self._adj: dict[str, list[str]] = {}      # source → [targets]
        self._rev_adj: dict[str, list[str]] = {}   # target → [sources]

    # -- Building ----------------------------------------------------------

    def load_chapter(self, chapter_dir: Path, chapter_num: int) -> int:
        """Load extraction.json, rosetta_stone.jsonl, and lean files from a chapter dir.

        Returns the number of nodes added.
        """
        chapter_dir = Path(chapter_dir)
        added = 0

        # 1. Parse extraction.json → nodes + NL edges
        extraction_path = chapter_dir / "extraction.json"
        if not extraction_path.exists():
            return 0

        with open(extraction_path, encoding="utf-8") as f:
            data = json.load(f)

        items = data.get("items", [])
        for item in items:
            item_id = item["id"]
            node_type = _TYPE_MAP.get(item.get("type", ""), NodeType.THEOREM)
            node = GraphNode(
                item_id=item_id,
                chapter=chapter_num,
                section=item.get("section", ""),
                node_type=node_type,
                statement=item.get("statement", ""),
            )
            self.nodes[item_id] = node
            added += 1

            # NL dependency edges
            for dep_id in item.get("dependencies", []):
                if dep_id.startswith("External:"):
                    # Defer to resolve_cross_chapter_refs
                    continue
                self._add_edge(GraphEdge(
                    source_id=item_id,
                    target_id=dep_id,
                    edge_type=EdgeType.NL_DEPENDENCY,
                ))

            # Store raw external refs on the node for later resolution
            ext_refs = [d for d in item.get("dependencies", []) if d.startswith("External:")]
            if ext_refs:
                # Temporarily store in a way we can retrieve later
                node._raw_external_refs = ext_refs  # type: ignore[attr-defined]

        # 2. Enrich from rosetta_stone.jsonl
        rosetta_path = chapter_dir / "rosetta_stone.jsonl"
        if rosetta_path.exists():
            with open(rosetta_path, encoding="utf-8") as f:
                for line in f:
                    line = line.strip()
                    if not line:
                        continue
                    try:
                        entry = json.loads(line)
                    except json.JSONDecodeError:
                        continue
                    rid = entry.get("id", "")
                    if rid in self.nodes:
                        node = self.nodes[rid]
                        node.mathlib_deps = entry.get("mathlib_identifiers", [])
                        node.attempts = entry.get("attempts", 0)
                        if node.attempts <= 1:
                            node.proof_difficulty = "easy"
                        elif node.attempts <= 5:
                            node.proof_difficulty = "medium"
                        else:
                            node.proof_difficulty = "hard"

        # 3. Enrich from lean files
        lean_dir = chapter_dir / "lean"
        if lean_dir.exists():
            for item_id, node in self.nodes.items():
                if node.chapter != chapter_num:
                    continue
                lean_file = _find_lean_file(lean_dir, item_id)
                if lean_file:
                    node.lean_file = str(lean_file)
                    try:
                        code = lean_file.read_text(encoding="utf-8")
                    except Exception:
                        continue
                    node.tactics_used = _extract_tactics(code)
                    node.axioms_declared = _extract_axiom_declarations(code)

                    # Lean-level Mathlib deps from code
                    lean_deps = _extract_lean_deps(code)
                    for dep in lean_deps:
                        self._add_edge(GraphEdge(
                            source_id=item_id,
                            target_id=dep,
                            edge_type=EdgeType.MATHLIB,
                        ))

                    # Axiom edges
                    for ax in node.axioms_declared:
                        self._add_edge(GraphEdge(
                            source_id=item_id,
                            target_id=ax,
                            edge_type=EdgeType.AXIOMATIZES,
                        ))

        return added

    def resolve_cross_chapter_refs(self) -> int:
        """Resolve External: references to actual items using the seed table.

        Returns the number of edges added.
        """
        resolved = 0
        for node in list(self.nodes.values()):
            ext_refs = getattr(node, "_raw_external_refs", [])
            for ref in ext_refs:
                concept = ref.replace("External:", "")
                target_id = _EXTERNAL_SEED.get(concept)
                if target_id and target_id in self.nodes:
                    self._add_edge(GraphEdge(
                        source_id=node.item_id,
                        target_id=target_id,
                        edge_type=EdgeType.CROSS_CHAPTER,
                    ))
                    resolved += 1
                elif concept in _MATH_EXTERNALS:
                    # Create an external node if not already present
                    ext_id = f"External:{concept}"
                    if ext_id not in self.nodes:
                        self.nodes[ext_id] = GraphNode(
                            item_id=ext_id,
                            chapter=0,
                            section="",
                            node_type=NodeType.EXTERNAL,
                            statement=f"External mathematical result: {concept}",
                        )
                    self._add_edge(GraphEdge(
                        source_id=node.item_id,
                        target_id=ext_id,
                        edge_type=EdgeType.CROSS_CHAPTER,
                    ))
                    resolved += 1
                else:
                    # Fuzzy fallback: try to find by normalized name
                    target = self._fuzzy_resolve(concept)
                    if target:
                        self._add_edge(GraphEdge(
                            source_id=node.item_id,
                            target_id=target,
                            edge_type=EdgeType.CROSS_CHAPTER,
                            confidence=0.7,
                        ))
                        resolved += 1
        return resolved

    def infer_concept_clusters(self) -> list[ConceptCluster]:
        """Group definitions with the same normalized concept name across chapters."""
        concept_groups: dict[str, list[str]] = {}
        for node in self.nodes.values():
            if node.node_type != NodeType.DEFINITION:
                continue
            key = self._normalize_concept(node.statement, node.item_id)
            if key:
                concept_groups.setdefault(key, []).append(node.item_id)

        clusters = []
        for key, ids in concept_groups.items():
            if len(ids) < 2:
                continue
            # Pick the item with the lowest chapter as canonical
            ids_sorted = sorted(ids, key=lambda x: self.nodes[x].chapter)
            cluster = ConceptCluster(
                canonical_id=ids_sorted[0],
                aliases=ids_sorted[1:],
            )
            # Find external refs that point to any of these
            for ref, target in _EXTERNAL_SEED.items():
                if target in ids:
                    cluster.external_refs.append(f"External:{ref}")
            clusters.append(cluster)
        return clusters

    def classify_domains(self) -> None:
        """Assign MathDomain to each node based on section mapping."""
        for node in self.nodes.values():
            if node.node_type == NodeType.EXTERNAL:
                continue
            # Try exact section match, then prefix match
            section = node.section
            if section in _SECTION_DOMAIN:
                node.domain = _SECTION_DOMAIN[section]
            else:
                # Try matching on chapter.section prefix (e.g., "4.B" from "4B")
                for prefix, domain in _SECTION_DOMAIN.items():
                    if section.replace(".", "").startswith(prefix.replace(".", "")):
                        node.domain = domain
                        break

    # -- Querying ----------------------------------------------------------

    def dependencies_of(self, item_id: str, transitive: bool = False) -> list[str]:
        """Get items that item_id depends on (targets of outgoing edges)."""
        if not transitive:
            return list(self._adj.get(item_id, []))
        visited: set[str] = set()
        self._walk_forward(item_id, visited)
        visited.discard(item_id)
        return sorted(visited)

    def dependents_of(self, item_id: str, transitive: bool = False) -> list[str]:
        """Get items that depend on item_id (sources of incoming edges)."""
        if not transitive:
            return list(self._rev_adj.get(item_id, []))
        visited: set[str] = set()
        self._walk_backward(item_id, visited)
        visited.discard(item_id)
        return sorted(visited)

    def topological_order(self) -> list[str]:
        """Return nodes in topological order (dependencies before dependents).

        Only includes NL_DEPENDENCY and CROSS_CHAPTER edges (the semantic graph).
        Uses Kahn's algorithm. If cycles exist, remaining nodes are appended.
        """
        # Build in-degree map for semantic edges only
        semantic_adj: dict[str, list[str]] = {}
        in_degree: dict[str, int] = {nid: 0 for nid in self.nodes}
        for edge in self.edges:
            if edge.edge_type not in (EdgeType.NL_DEPENDENCY, EdgeType.CROSS_CHAPTER):
                continue
            if edge.source_id not in self.nodes or edge.target_id not in self.nodes:
                continue
            semantic_adj.setdefault(edge.target_id, []).append(edge.source_id)
            in_degree.setdefault(edge.source_id, 0)
            in_degree[edge.source_id] = in_degree.get(edge.source_id, 0) + 1

        queue = [nid for nid, deg in in_degree.items() if deg == 0]
        queue.sort()  # deterministic
        result = []
        while queue:
            nid = queue.pop(0)
            result.append(nid)
            for dependent in semantic_adj.get(nid, []):
                in_degree[dependent] -= 1
                if in_degree[dependent] == 0:
                    queue.append(dependent)
                    queue.sort()

        # Append any remaining (cycle members) at the end
        remaining = [nid for nid in self.nodes if nid not in set(result)]
        remaining.sort()
        result.extend(remaining)
        return result

    def items_by_domain(self, domain: MathDomain) -> list[GraphNode]:
        """Return all nodes in a given domain."""
        return [n for n in self.nodes.values() if n.domain == domain]

    def shared_definitions(self) -> list[ConceptCluster]:
        """Return concept clusters (definitions duplicated across chapters)."""
        return self.infer_concept_clusters()

    def has_cycles(self) -> bool:
        """Check if the semantic dependency graph has cycles."""
        topo = self.topological_order()
        # If topological_order had to append remaining nodes, there are cycles
        semantic_nodes = set()
        for edge in self.edges:
            if edge.edge_type in (EdgeType.NL_DEPENDENCY, EdgeType.CROSS_CHAPTER):
                semantic_nodes.add(edge.source_id)
                semantic_nodes.add(edge.target_id)
        # Check via in-degree: if all got processed, no cycles
        in_degree: dict[str, int] = {nid: 0 for nid in self.nodes}
        for edge in self.edges:
            if edge.edge_type not in (EdgeType.NL_DEPENDENCY, EdgeType.CROSS_CHAPTER):
                continue
            if edge.source_id in self.nodes and edge.target_id in self.nodes:
                in_degree[edge.source_id] = in_degree.get(edge.source_id, 0) + 1
        queue = [nid for nid, deg in in_degree.items() if deg == 0]
        processed = 0
        adj: dict[str, list[str]] = {}
        for edge in self.edges:
            if edge.edge_type in (EdgeType.NL_DEPENDENCY, EdgeType.CROSS_CHAPTER):
                if edge.source_id in self.nodes and edge.target_id in self.nodes:
                    adj.setdefault(edge.target_id, []).append(edge.source_id)
        while queue:
            nid = queue.pop()
            processed += 1
            for dep in adj.get(nid, []):
                in_degree[dep] -= 1
                if in_degree[dep] == 0:
                    queue.append(dep)
        return processed < len(self.nodes)

    # -- Output ------------------------------------------------------------

    def to_dot(self, filter_chapter: int | None = None) -> str:
        """Generate DOT (Graphviz) representation."""
        lines = ["digraph MWG {", "  rankdir=TB;", '  node [shape=box, fontsize=10];']

        # Color by domain
        domain_colors = {
            MathDomain.PREFERENCE_THEORY: "#FFD700",
            MathDomain.CHOICE_THEORY: "#87CEEB",
            MathDomain.CONSUMER_DEMAND: "#90EE90",
            MathDomain.UTILITY_THEORY: "#FFB6C1",
            MathDomain.EXPENDITURE_DUALITY: "#DDA0DD",
            MathDomain.REVEALED_PREFERENCE: "#FFA07A",
            MathDomain.WELFARE_AGGREGATION: "#98FB98",
            MathDomain.COMPARATIVE_STATICS: "#F0E68C",
            MathDomain.GENERAL: "#D3D3D3",
        }

        shape_map = {
            NodeType.DEFINITION: "box",
            NodeType.THEOREM: "ellipse",
            NodeType.AXIOM: "diamond",
            NodeType.EXAMPLE: "octagon",
            NodeType.EXTERNAL: "hexagon",
        }

        for nid, node in self.nodes.items():
            if filter_chapter is not None and node.chapter != filter_chapter:
                continue
            color = domain_colors.get(node.domain, "#D3D3D3")
            shape = shape_map.get(node.node_type, "box")
            label = nid.replace("_", "\\n")
            lines.append(f'  "{nid}" [label="{label}", shape={shape}, '
                         f'style=filled, fillcolor="{color}"];')

        visible = set()
        if filter_chapter is not None:
            visible = {nid for nid, n in self.nodes.items() if n.chapter == filter_chapter}

        for edge in self.edges:
            if filter_chapter is not None:
                if edge.source_id not in visible and edge.target_id not in visible:
                    continue
            style = "solid"
            if edge.edge_type == EdgeType.CROSS_CHAPTER:
                style = "dashed"
            elif edge.edge_type == EdgeType.MATHLIB:
                style = "dotted"
            lines.append(f'  "{edge.source_id}" -> "{edge.target_id}" [style={style}];')

        lines.append("}")
        return "\n".join(lines)

    def to_json(self) -> dict:
        """Serialize graph to a JSON-compatible dict."""
        return {
            "nodes": {nid: asdict(n) for nid, n in self.nodes.items()},
            "edges": [asdict(e) for e in self.edges],
            "stats": self._compute_stats(),
        }

    def summary(self) -> str:
        """Human-readable summary of the graph."""
        stats = self._compute_stats()
        lines = [
            "=== Dependency Graph Summary ===",
            f"Nodes: {stats['total_nodes']}",
            f"Edges: {stats['total_edges']}",
            "",
            "By type:",
        ]
        for t, count in sorted(stats["by_type"].items()):
            lines.append(f"  {t}: {count}")
        lines.append("")
        lines.append("By chapter:")
        for ch, count in sorted(stats["by_chapter"].items()):
            lines.append(f"  Ch{ch}: {count}")
        lines.append("")
        lines.append("By domain:")
        for d, count in sorted(stats["by_domain"].items()):
            lines.append(f"  {d}: {count}")
        lines.append("")
        lines.append("Edge types:")
        for et, count in sorted(stats["edge_types"].items()):
            lines.append(f"  {et}: {count}")

        # Top items by dependents
        lines.append("")
        lines.append("Most-depended-on items (top 10):")
        dep_counts = [(nid, len(self._rev_adj.get(nid, []))) for nid in self.nodes]
        dep_counts.sort(key=lambda x: -x[1])
        for nid, count in dep_counts[:10]:
            if count == 0:
                break
            node = self.nodes[nid]
            lines.append(f"  {nid} ({node.node_type.value}): {count} dependents")

        return "\n".join(lines)

    def save(self, path: Path) -> None:
        """Save graph to JSON file."""
        path = Path(path)
        path.parent.mkdir(parents=True, exist_ok=True)
        with open(path, "w", encoding="utf-8") as f:
            json.dump(self.to_json(), f, indent=2, ensure_ascii=False)

    @classmethod
    def load(cls, path: Path) -> "DependencyGraph":
        """Load graph from JSON file."""
        path = Path(path)
        with open(path, encoding="utf-8") as f:
            data = json.load(f)

        graph = cls()
        for nid, ndata in data.get("nodes", {}).items():
            # Convert string enums back
            ndata["node_type"] = NodeType(ndata["node_type"])
            ndata["domain"] = MathDomain(ndata["domain"])
            graph.nodes[nid] = GraphNode(**ndata)

        for edata in data.get("edges", []):
            edata["edge_type"] = EdgeType(edata["edge_type"])
            edge = GraphEdge(**edata)
            graph._add_edge(edge)

        return graph

    # -- Internal ----------------------------------------------------------

    def _add_edge(self, edge: GraphEdge) -> None:
        """Add an edge and update adjacency lists."""
        self.edges.append(edge)
        self._adj.setdefault(edge.source_id, []).append(edge.target_id)
        self._rev_adj.setdefault(edge.target_id, []).append(edge.source_id)

    def _walk_forward(self, node_id: str, visited: set[str]) -> None:
        """DFS over outgoing edges."""
        if node_id in visited:
            return
        visited.add(node_id)
        for target in self._adj.get(node_id, []):
            self._walk_forward(target, visited)

    def _walk_backward(self, node_id: str, visited: set[str]) -> None:
        """DFS over incoming edges."""
        if node_id in visited:
            return
        visited.add(node_id)
        for source in self._rev_adj.get(node_id, []):
            self._walk_backward(source, visited)

    def _fuzzy_resolve(self, concept: str) -> str | None:
        """Try to resolve an external concept name to an item ID by fuzzy matching."""
        # Normalize the concept name
        normalized = concept.lower().replace("_", " ").replace("-", " ")
        best_match = None
        best_score = 0.0

        for nid, node in self.nodes.items():
            if node.node_type not in (NodeType.DEFINITION, NodeType.THEOREM):
                continue
            # Check if concept words appear in the statement
            words = normalized.split()
            statement_lower = node.statement.lower()
            matching = sum(1 for w in words if w in statement_lower)
            score = matching / len(words) if words else 0
            if score > best_score and score >= 0.6:
                best_score = score
                best_match = nid

        return best_match

    @staticmethod
    def _normalize_concept(statement: str, item_id: str) -> str | None:
        """Extract a normalized concept name for clustering."""
        # Try to extract from ID patterns like "Definition_3.B.1" → skip
        # Focus on statement content for clustering
        s = statement.lower()
        # Extract "The X is ..." pattern
        m = re.match(r"the\s+(.+?)\s+(?:is|are)\b", s)
        if m:
            concept = m.group(1).strip()
            # Normalize: remove articles, extra whitespace
            concept = re.sub(r"\b(a|an|the)\b", "", concept).strip()
            concept = re.sub(r"\s+", " ", concept)
            if len(concept) > 5:
                return concept
        return None

    def _compute_stats(self) -> dict:
        """Compute summary statistics."""
        by_type: dict[str, int] = {}
        by_chapter: dict[str, int] = {}
        by_domain: dict[str, int] = {}
        for node in self.nodes.values():
            by_type[node.node_type.value] = by_type.get(node.node_type.value, 0) + 1
            ch = str(node.chapter)
            by_chapter[ch] = by_chapter.get(ch, 0) + 1
            by_domain[node.domain.value] = by_domain.get(node.domain.value, 0) + 1

        edge_types: dict[str, int] = {}
        for edge in self.edges:
            edge_types[edge.edge_type.value] = edge_types.get(edge.edge_type.value, 0) + 1

        return {
            "total_nodes": len(self.nodes),
            "total_edges": len(self.edges),
            "by_type": by_type,
            "by_chapter": by_chapter,
            "by_domain": by_domain,
            "edge_types": edge_types,
        }


# ---------------------------------------------------------------------------
# Convenience builder
# ---------------------------------------------------------------------------

def build_graph(chapter_dirs: list[tuple[Path, int]]) -> DependencyGraph:
    """Build a complete dependency graph from multiple chapter directories.

    Args:
        chapter_dirs: list of (directory_path, chapter_number) tuples

    Returns:
        Fully constructed DependencyGraph
    """
    graph = DependencyGraph()
    for chapter_dir, chapter_num in chapter_dirs:
        graph.load_chapter(chapter_dir, chapter_num)
    graph.resolve_cross_chapter_refs()
    graph.classify_domains()
    return graph
