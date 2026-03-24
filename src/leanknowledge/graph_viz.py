"""Visualization for the MWG dependency graph.

Two output modes:
1. Terminal — rich tables and trees (metrics table, layer/deps/top trees)
2. HTML — self-contained vis.js interactive graph
"""

from __future__ import annotations

import html
import json
from typing import TYPE_CHECKING

from rich.table import Table
from rich.tree import Tree
from rich.text import Text

if TYPE_CHECKING:
    from .graph_metrics import NodeImportance

from .dependency_graph import (
    DependencyGraph,
    EdgeType,
    MathDomain,
    NodeType,
)


# ---------------------------------------------------------------------------
# Colour constants
# ---------------------------------------------------------------------------

_TYPE_STYLE: dict[NodeType, str] = {
    NodeType.DEFINITION: "cyan",
    NodeType.THEOREM: "green",
    NodeType.AXIOM: "yellow",
    NodeType.EXAMPLE: "blue",
    NodeType.EXTERNAL: "dim",
}

_DOMAIN_HEX: dict[MathDomain, str] = {
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

_TYPE_SHAPE: dict[NodeType, str] = {
    NodeType.DEFINITION: "box",
    NodeType.THEOREM: "ellipse",
    NodeType.AXIOM: "diamond",
    NodeType.EXAMPLE: "triangle",
    NodeType.EXTERNAL: "hexagon",
}


# ---------------------------------------------------------------------------
# Terminal: metrics table
# ---------------------------------------------------------------------------

def render_metrics_table(
    importance: dict[str, NodeImportance],
    top_k: int = 20,
) -> Table:
    """Build a rich Table of the top-k nodes ranked by importance."""
    table = Table(title=f"Top {top_k} Nodes by Importance")
    table.add_column("Rank", justify="right", style="bold")
    table.add_column("Node ID", style="cyan")
    table.add_column("Type")
    table.add_column("Composite", justify="right")
    table.add_column("PageRank", justify="right")
    table.add_column("In-Degree", justify="right")
    table.add_column("Betweenness", justify="right")
    table.add_column("Trans. Deps", justify="right")

    from .graph_metrics import rank_nodes
    ranked = rank_nodes(importance, top_k)
    for ni in ranked:
        table.add_row(
            str(ni.rank),
            ni.node_id,
            "",
            f"{ni.composite:.3f}",
            f"{ni.pagerank:.4f}",
            str(ni.in_degree),
            f"{ni.betweenness:.4f}",
            str(ni.transitive_dependents),
        )
    return table


# ---------------------------------------------------------------------------
# Terminal: tree rendering
# ---------------------------------------------------------------------------

def _node_label(nid: str, graph: DependencyGraph,
                importance: dict[str, NodeImportance] | None) -> Text:
    """Build a styled label for a tree node."""
    node = graph.nodes.get(nid)
    style = _TYPE_STYLE.get(node.node_type, "") if node else "dim"
    score = ""
    if importance and nid in importance:
        score = f" [{importance[nid].composite:.2f}]"
    txt = Text(f"{nid}{score}", style=style)
    return txt


def render_tree(
    graph: DependencyGraph,
    importance: dict[str, NodeImportance] | None = None,
    mode: str = "layers",
    node_id: str | None = None,
    max_depth: int = 4,
    top_n: int = 5,
) -> Tree:
    """Render a rich Tree of the dependency graph.

    Modes:
        layers  — topological generations, top-N per layer
        deps    — subtree from a specific node (dependencies downward)
        top     — top-N most important nodes with their direct dependents
    """
    if mode == "layers":
        return _tree_layers(graph, importance, top_n)
    elif mode == "deps":
        if node_id is None:
            raise ValueError("mode='deps' requires node_id")
        return _tree_deps(graph, importance, node_id, max_depth)
    elif mode == "top":
        return _tree_top(graph, importance, top_n)
    else:
        raise ValueError(f"Unknown tree mode: {mode!r}")


def _tree_layers(
    graph: DependencyGraph,
    importance: dict[str, NodeImportance] | None,
    top_n: int,
) -> Tree:
    """Topological generations — roots at top, leaves at bottom."""
    import networkx as nx
    from .graph_metrics import _build_nx_graph

    G = _build_nx_graph(graph)
    try:
        generations = list(nx.topological_generations(G))
    except nx.NetworkXUnfeasible:
        generations = [list(G.nodes)]

    root = Tree("[bold]Dependency Layers[/bold]")
    for i, gen in enumerate(generations):
        # Sort by importance (highest first) within each layer
        if importance:
            gen_sorted = sorted(gen, key=lambda n: importance[n].composite
                                if n in importance else 0, reverse=True)
        else:
            gen_sorted = sorted(gen)
        shown = gen_sorted[:top_n]
        remaining = len(gen_sorted) - len(shown)
        label = f"[bold]Layer {i}[/bold] ({len(gen)} nodes)"
        layer_branch = root.add(label)
        for nid in shown:
            layer_branch.add(_node_label(nid, graph, importance))
        if remaining > 0:
            layer_branch.add(Text(f"... +{remaining} more", style="dim"))
    return root


def _tree_deps(
    graph: DependencyGraph,
    importance: dict[str, NodeImportance] | None,
    node_id: str,
    max_depth: int,
) -> Tree:
    """Subtree showing what node_id depends on, depth-capped."""
    root = Tree(_node_label(node_id, graph, importance))
    seen: set[str] = set()
    _add_deps_recursive(root, graph, importance, node_id, seen, 0, max_depth)
    return root


def _add_deps_recursive(
    parent: Tree,
    graph: DependencyGraph,
    importance: dict[str, NodeImportance] | None,
    node_id: str,
    seen: set[str],
    depth: int,
    max_depth: int,
) -> None:
    if depth >= max_depth:
        deps = graph.dependencies_of(node_id)
        if deps:
            parent.add(Text(f"... ({len(deps)} deps, depth limit)", style="dim"))
        return
    seen.add(node_id)
    for dep_id in sorted(graph.dependencies_of(node_id)):
        if dep_id in seen:
            parent.add(Text(f"{dep_id} [seen]", style="dim"))
            continue
        child = parent.add(_node_label(dep_id, graph, importance))
        _add_deps_recursive(child, graph, importance, dep_id, seen, depth + 1, max_depth)


def _tree_top(
    graph: DependencyGraph,
    importance: dict[str, NodeImportance] | None,
    top_n: int,
) -> Tree:
    """Top-N most important nodes with their direct dependents."""
    root = Tree("[bold]Top Nodes[/bold]")
    if not importance:
        root.add(Text("No importance data", style="dim"))
        return root

    from .graph_metrics import rank_nodes
    ranked = rank_nodes(importance, top_n)
    for ni in ranked:
        branch = root.add(_node_label(ni.node_id, graph, importance))
        dependents = graph.dependents_of(ni.node_id)
        for dep_id in sorted(dependents)[:5]:
            branch.add(_node_label(dep_id, graph, importance))
        remaining = len(dependents) - 5
        if remaining > 0:
            branch.add(Text(f"... +{remaining} more dependents", style="dim"))
    return root


# ---------------------------------------------------------------------------
# HTML: vis.js interactive graph
# ---------------------------------------------------------------------------

def graph_to_html(
    graph: DependencyGraph,
    importance: dict[str, NodeImportance] | None = None,
) -> str:
    """Generate a self-contained HTML file with vis.js interactive graph."""

    # Build node list
    vis_nodes = []
    for nid, node in graph.nodes.items():
        score = importance[nid].composite if importance and nid in importance else 0.0
        size = 10 + score * 40  # 10..50
        vis_nodes.append({
            "id": nid,
            "label": nid,
            "color": _DOMAIN_HEX.get(node.domain, "#D3D3D3"),
            "shape": _TYPE_SHAPE.get(node.node_type, "dot"),
            "size": round(size, 1),
            "title": _hover_html(node, importance),
            "group": node.domain.value,
            "chapter": node.chapter,
            "nodeType": node.node_type.value,
        })

    # Build edge list
    vis_edges = []
    for edge in graph.edges:
        if edge.source_id not in graph.nodes or edge.target_id not in graph.nodes:
            continue
        dashes = False
        if edge.edge_type == EdgeType.CROSS_CHAPTER:
            dashes = True
        elif edge.edge_type == EdgeType.MATHLIB:
            dashes = [2, 4]  # dotted
        vis_edges.append({
            "from": edge.source_id,
            "to": edge.target_id,
            "dashes": dashes,
            "edgeType": edge.edge_type.value,
        })

    graph_data = json.dumps({"nodes": vis_nodes, "edges": vis_edges}, ensure_ascii=False)

    # Chapters and domains for filter controls
    chapters = sorted({n.chapter for n in graph.nodes.values()})
    domains = sorted({n.domain.value for n in graph.nodes.values()})
    node_types = sorted({n.node_type.value for n in graph.nodes.values()})

    return _HTML_TEMPLATE.format(
        GRAPH_DATA=graph_data,
        CHAPTERS_JSON=json.dumps(chapters),
        DOMAINS_JSON=json.dumps(domains),
        TYPES_JSON=json.dumps(node_types),
        NODE_COUNT=len(vis_nodes),
        EDGE_COUNT=len(vis_edges),
    )


def _hover_html(node, importance: dict[str, NodeImportance] | None) -> str:
    """Build HTML tooltip for a node."""
    parts = [
        f"<b>{html.escape(node.item_id)}</b>",
        f"Type: {node.node_type.value}",
        f"Chapter: {node.chapter} | Section: {node.section}",
        f"Domain: {node.domain.value}",
        f"Difficulty: {node.proof_difficulty}",
    ]
    stmt = node.statement
    if len(stmt) > 200:
        stmt = stmt[:200] + "..."
    parts.append(f"<br>{html.escape(stmt)}")
    if importance and node.item_id in importance:
        ni = importance[node.item_id]
        parts.append(f"<br><b>Rank:</b> {ni.rank} | <b>Composite:</b> {ni.composite:.3f}")
        parts.append(f"PageRank: {ni.pagerank:.4f} | In-Degree: {ni.in_degree}")
        parts.append(f"Betweenness: {ni.betweenness:.4f} | Trans. Deps: {ni.transitive_dependents}")
    return "<br>".join(parts)


# ---------------------------------------------------------------------------
# HTML template
# ---------------------------------------------------------------------------

_HTML_TEMPLATE = """<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>MWG Dependency Graph</title>
<script src="https://unpkg.com/vis-network@9.1.9/standalone/umd/vis-network.min.js"></script>
<style>
  * {{ margin: 0; padding: 0; box-sizing: border-box; }}
  body {{ font-family: system-ui, -apple-system, sans-serif; background: #1a1a2e; color: #e0e0e0; }}
  #controls {{ padding: 10px 16px; background: #16213e; display: flex; flex-wrap: wrap; gap: 10px; align-items: center; }}
  #controls label {{ font-size: 13px; }}
  #controls select, #controls input {{ background: #0f3460; color: #e0e0e0; border: 1px solid #444; padding: 4px 8px; border-radius: 4px; font-size: 13px; }}
  #controls button {{ background: #533483; color: #fff; border: none; padding: 5px 12px; border-radius: 4px; cursor: pointer; font-size: 13px; }}
  #controls button:hover {{ background: #6a4c93; }}
  #search {{ width: 180px; }}
  #graph {{ width: 100%; height: calc(100vh - 90px); }}
  #info {{ position: fixed; bottom: 10px; left: 10px; background: rgba(22,33,62,0.9); padding: 8px 14px; border-radius: 6px; font-size: 12px; }}
  #detail {{ position: fixed; right: 10px; top: 60px; width: 320px; max-height: 80vh; overflow-y: auto;
             background: rgba(22,33,62,0.95); padding: 14px; border-radius: 8px; display: none; font-size: 13px; line-height: 1.5; }}
  #detail h3 {{ margin-bottom: 6px; color: #e2b714; }}
</style>
</head>
<body>
<div id="controls">
  <label>Chapter: <select id="filterChapter"><option value="all">All</option></select></label>
  <label>Domain: <select id="filterDomain"><option value="all">All</option></select></label>
  <label>Type: <select id="filterType"><option value="all">All</option></select></label>
  <input id="search" type="text" placeholder="Search node ID...">
  <button id="btnHierarchical">Hierarchical</button>
  <button id="btnPhysics">Physics</button>
  <button id="btnReset">Reset</button>
</div>
<div id="graph"></div>
<div id="info">{NODE_COUNT} nodes | {EDGE_COUNT} edges</div>
<div id="detail"></div>

<script>
var GRAPH_DATA = {GRAPH_DATA};
var CHAPTERS = {CHAPTERS_JSON};
var DOMAINS = {DOMAINS_JSON};
var TYPES = {TYPES_JSON};

// Populate filter dropdowns
(function() {{
  var sel;
  sel = document.getElementById('filterChapter');
  CHAPTERS.forEach(function(ch) {{ var o = document.createElement('option'); o.value = ch; o.textContent = 'Ch ' + ch; sel.appendChild(o); }});
  sel = document.getElementById('filterDomain');
  DOMAINS.forEach(function(d) {{ var o = document.createElement('option'); o.value = d; o.textContent = d; sel.appendChild(o); }});
  sel = document.getElementById('filterType');
  TYPES.forEach(function(t) {{ var o = document.createElement('option'); o.value = t; o.textContent = t; sel.appendChild(o); }});
}})();

var allNodes = new vis.DataSet(GRAPH_DATA.nodes);
var allEdges = new vis.DataSet(GRAPH_DATA.edges);

var container = document.getElementById('graph');
var data = {{ nodes: allNodes, edges: allEdges }};
var options = {{
  physics: {{ solver: 'forceAtlas2Based', forceAtlas2Based: {{ gravitationalConstant: -80, springLength: 120 }}, stabilization: {{ iterations: 200 }} }},
  interaction: {{ hover: true, tooltipDelay: 100 }},
  edges: {{ arrows: 'to', color: {{ color: '#555', highlight: '#fff' }}, width: 1 }},
  nodes: {{ font: {{ color: '#e0e0e0', size: 11 }} }},
}};
var network = new vis.Network(container, data, options);

// Click → detail panel
network.on('click', function(params) {{
  var panel = document.getElementById('detail');
  if (params.nodes.length === 0) {{ panel.style.display = 'none'; return; }}
  var nodeId = params.nodes[0];
  var nodeData = allNodes.get(nodeId);
  if (!nodeData) return;
  panel.innerHTML = '<h3>' + nodeData.id + '</h3>' + (nodeData.title || '');
  panel.style.display = 'block';
}});

// Filtering
function applyFilters() {{
  var ch = document.getElementById('filterChapter').value;
  var dom = document.getElementById('filterDomain').value;
  var typ = document.getElementById('filterType').value;
  var q = document.getElementById('search').value.toLowerCase();

  var visibleIds = new Set();
  GRAPH_DATA.nodes.forEach(function(n) {{
    var show = true;
    if (ch !== 'all' && n.chapter != ch) show = false;
    if (dom !== 'all' && n.group !== dom) show = false;
    if (typ !== 'all' && n.nodeType !== typ) show = false;
    if (q && n.id.toLowerCase().indexOf(q) === -1) show = false;
    if (show) visibleIds.add(n.id);
  }});

  allNodes.forEach(function(n) {{
    allNodes.update({{ id: n.id, hidden: !visibleIds.has(n.id) }});
  }});
  allEdges.forEach(function(e) {{
    allEdges.update({{ id: e.id, hidden: !(visibleIds.has(e.from) && visibleIds.has(e.to)) }});
  }});
}}

document.getElementById('filterChapter').addEventListener('change', applyFilters);
document.getElementById('filterDomain').addEventListener('change', applyFilters);
document.getElementById('filterType').addEventListener('change', applyFilters);
document.getElementById('search').addEventListener('input', applyFilters);

document.getElementById('btnHierarchical').addEventListener('click', function() {{
  network.setOptions({{ layout: {{ hierarchical: {{ direction: 'UD', sortMethod: 'directed', levelSeparation: 120 }} }}, physics: false }});
}});
document.getElementById('btnPhysics').addEventListener('click', function() {{
  network.setOptions({{ layout: {{ hierarchical: false }}, physics: {{ enabled: true, solver: 'forceAtlas2Based' }} }});
}});
document.getElementById('btnReset').addEventListener('click', function() {{
  document.getElementById('filterChapter').value = 'all';
  document.getElementById('filterDomain').value = 'all';
  document.getElementById('filterType').value = 'all';
  document.getElementById('search').value = '';
  applyFilters();
  network.setOptions({{ layout: {{ hierarchical: false }}, physics: {{ enabled: true, solver: 'forceAtlas2Based' }} }});
  network.fit();
}});
</script>
</body>
</html>
"""
