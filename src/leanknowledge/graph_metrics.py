"""Importance metrics for the MWG dependency graph.

Computes PageRank, in-degree, betweenness centrality, and transitive dependent
count over the semantic subgraph (NL_DEPENDENCY + CROSS_CHAPTER edges).
Produces a composite importance score per node.
"""

from __future__ import annotations

from dataclasses import dataclass
from typing import TYPE_CHECKING

import networkx as nx

if TYPE_CHECKING:
    from .dependency_graph import DependencyGraph

from .dependency_graph import EdgeType


# ---------------------------------------------------------------------------
# Data
# ---------------------------------------------------------------------------

DEFAULT_WEIGHTS: dict[str, float] = {
    "pagerank": 0.35,
    "transitive_dependents": 0.30,
    "in_degree": 0.20,
    "betweenness": 0.15,
}


@dataclass
class NodeImportance:
    node_id: str
    # Raw metrics
    pagerank: float
    in_degree: int
    betweenness: float
    transitive_dependents: int
    # Normalised to [0, 1]
    pagerank_norm: float
    in_degree_norm: float
    betweenness_norm: float
    transitive_dependents_norm: float
    # Weighted composite [0, 1]
    composite: float
    # 1 = most important
    rank: int = 0


# ---------------------------------------------------------------------------
# Internal helpers
# ---------------------------------------------------------------------------

_SEMANTIC_TYPES = frozenset({EdgeType.NL_DEPENDENCY, EdgeType.CROSS_CHAPTER})


def _build_nx_graph(graph: DependencyGraph) -> nx.DiGraph:
    """Build a NetworkX DiGraph from semantic edges only."""
    G = nx.DiGraph()
    G.add_nodes_from(graph.nodes.keys())
    for edge in graph.edges:
        if edge.edge_type in _SEMANTIC_TYPES:
            if edge.source_id in graph.nodes and edge.target_id in graph.nodes:
                G.add_edge(edge.source_id, edge.target_id)
    return G


def _minmax(values: list[float]) -> list[float]:
    """Min-max normalise a list of floats to [0, 1]."""
    lo = min(values) if values else 0.0
    hi = max(values) if values else 0.0
    span = hi - lo
    if span == 0:
        return [0.0] * len(values)
    return [(v - lo) / span for v in values]


# ---------------------------------------------------------------------------
# Public API
# ---------------------------------------------------------------------------

def compute_importance(
    graph: DependencyGraph,
    weights: dict[str, float] | None = None,
) -> dict[str, NodeImportance]:
    """Compute importance metrics for every node.

    Args:
        graph: A populated DependencyGraph.
        weights: Optional weight dict (keys: pagerank, transitive_dependents,
                 in_degree, betweenness). Defaults to DEFAULT_WEIGHTS.

    Returns:
        Mapping of node_id → NodeImportance (ranked, 1 = most important).
    """
    w = weights or DEFAULT_WEIGHTS
    G = _build_nx_graph(graph)
    node_ids = list(G.nodes)

    if not node_ids:
        return {}

    # Raw metrics
    pr = nx.pagerank(G, alpha=0.85)
    bt = nx.betweenness_centrality(G, normalized=True)

    raw_pr = [pr.get(n, 0.0) for n in node_ids]
    raw_in = [G.in_degree(n) for n in node_ids]
    raw_bt = [bt.get(n, 0.0) for n in node_ids]

    # Transitive dependents (reverse reachability)
    G_rev = G.reverse()
    raw_td = []
    for n in node_ids:
        desc = nx.descendants(G_rev, n)
        raw_td.append(len(desc))

    # Normalise
    norm_pr = _minmax(raw_pr)
    norm_in = _minmax([float(x) for x in raw_in])
    norm_bt = _minmax(raw_bt)
    norm_td = _minmax([float(x) for x in raw_td])

    # Composite
    results: dict[str, NodeImportance] = {}
    for i, nid in enumerate(node_ids):
        composite = (
            w.get("pagerank", 0.0) * norm_pr[i]
            + w.get("in_degree", 0.0) * norm_in[i]
            + w.get("betweenness", 0.0) * norm_bt[i]
            + w.get("transitive_dependents", 0.0) * norm_td[i]
        )
        results[nid] = NodeImportance(
            node_id=nid,
            pagerank=raw_pr[i],
            in_degree=raw_in[i],
            betweenness=raw_bt[i],
            transitive_dependents=raw_td[i],
            pagerank_norm=norm_pr[i],
            in_degree_norm=norm_in[i],
            betweenness_norm=norm_bt[i],
            transitive_dependents_norm=norm_td[i],
            composite=composite,
        )

    # Rank by composite descending
    ranked = sorted(results.values(), key=lambda x: x.composite, reverse=True)
    for pos, ni in enumerate(ranked, 1):
        ni.rank = pos

    return results


def rank_nodes(
    importance: dict[str, NodeImportance],
    top_k: int = 20,
) -> list[NodeImportance]:
    """Return the top-k most important nodes, sorted by rank."""
    ranked = sorted(importance.values(), key=lambda x: x.rank)
    return ranked[:top_k]
