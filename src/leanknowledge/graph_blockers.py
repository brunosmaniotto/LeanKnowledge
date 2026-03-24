"""Blocker centrality recommender — identifies External: dependencies that block
the most downstream items and recommends sources for formalization.

Usage:
    from leanknowledge.graph_blockers import compute_blocker_metrics, format_blocker_report
    blockers = compute_blocker_metrics(graph)
    print(format_blocker_report(blockers, top_k=20))
"""

from __future__ import annotations

from dataclasses import dataclass, field
from typing import TYPE_CHECKING

if TYPE_CHECKING:
    from .dependency_graph import DependencyGraph

# ---------------------------------------------------------------------------
# Source map: External: name → (category, authoritative source)
# ---------------------------------------------------------------------------

_SOURCE_MAP: dict[str, tuple[str, str]] = {
    # Mathlib-available
    "separating_hyperplane_theorem": ("mathlib", "Mathlib.Analysis.NormedSpace.HahnBanach"),
    "Brouwer_fixed_point_theorem": ("mathlib", "Mathlib.Topology.MetricSpace.Baire (partial)"),
    "implicit_function_theorem": ("mathlib", "Mathlib.Analysis.Calculus.Implicit"),
    "Weierstrass_extreme_value_theorem": ("mathlib", "Mathlib.Topology.Order.Basic"),
    "Zorns_lemma": ("mathlib", "Mathlib.Order.Zorn"),
    "Jensen_inequality": ("mathlib", "Mathlib.Analysis.MeanInequalities"),
    "chain_rule": ("mathlib", "Mathlib.Analysis.Calculus.FDeriv.Comp"),
    "intermediate_value_theorem": ("mathlib", "Mathlib.Topology.Order.IntermediateValue"),
    "inverse_function_theorem": ("mathlib", "Mathlib.Analysis.Calculus.Inverse"),
    "Bayes_rule": ("mathlib", "Mathlib.Probability.ConditionalProbability"),
    "Frobenius_theorem": ("mathlib", "Mathlib.LinearAlgebra.Matrix.Charpoly.Frobenius"),
    "Bolzano_Weierstrass": ("mathlib", "Mathlib.Topology.Sequences"),
    "mean_value_theorem": ("mathlib", "Mathlib.Analysis.Calculus.MeanValue"),
    "dominated_convergence_theorem": ("mathlib", "Mathlib.MeasureTheory.Integral.DominatedConvergence"),
    "Fubini_theorem": ("mathlib", "Mathlib.MeasureTheory.Integral.Fubini"),
    "Radon_Nikodym": ("mathlib", "Mathlib.MeasureTheory.Decomposition.RadonNikodym"),
    "Hahn_Banach": ("mathlib", "Mathlib.Analysis.NormedSpace.HahnBanach"),
    "open_mapping_theorem": ("mathlib", "Mathlib.Analysis.NormedSpace.OperatorNorm.OpenMapping"),

    # Standard textbook references
    "Kakutani_fixed_point_theorem": ("textbook", "Aliprantis & Border, 'Infinite Dimensional Analysis' Ch.17"),
    "envelope_theorem": ("textbook", "Milgrom & Segal (2002), Econometrica"),
    "Kuhn_Tucker_theorem": ("textbook", "Sundaram, 'Optimization Theory' Ch.7"),
    "Kuhn_Tucker_sufficiency": ("textbook", "Sundaram, 'Optimization Theory' Ch.7"),
    "Gorman_form": ("textbook", "Gorman (1961), Econometrica"),
    "regular_equilibrium": ("textbook", "Debreu (1970), Econometrica"),
    "Euler_formula_homogeneous_functions": ("textbook", "Lang, 'Real and Functional Analysis'"),
    "tatonnement_stability": ("textbook", "Arrow & Hahn (1971), 'General Competitive Analysis'"),
    "Bellman_equation": ("textbook", "Stokey, Lucas & Prescott (1989), 'Recursive Methods'"),
    "golden_rule": ("textbook", "Stokey, Lucas & Prescott (1989), Ch.2"),
    "Shepards_lemma": ("textbook", "Varian, 'Microeconomic Analysis' 3rd ed., Ch.4"),
    "Slutsky_decomposition": ("textbook", "Varian, 'Microeconomic Analysis' Ch.8"),
    "integrability": ("textbook", "Hurwicz & Uzawa (1971)"),
    "Berge_maximum_theorem": ("textbook", "Aliprantis & Border, 'Infinite Dimensional Analysis' Ch.17"),
    "Sards_theorem": ("textbook", "Guillemin & Pollack, 'Differential Topology' Ch.1"),
    "minimax_theorem": ("textbook", "von Neumann (1928), Math. Annalen"),
    "Lyapunov_convexity_theorem": ("textbook", "Diestel & Uhl, 'Vector Measures' Ch.IX"),

    # Economics-internal (cross-chapter MWG)
    "Nash_equilibrium": ("cross_chapter", "Definition_8.D.1"),
    "Pareto_optimality": ("cross_chapter", "Definition_16.B.4"),
    "first_welfare_theorem": ("cross_chapter", "Proposition_16.C.1"),
    "second_welfare_theorem": ("cross_chapter", "Proposition_16.D.1"),
    "expected_utility": ("cross_chapter", "Theorem_6.B.2"),
    "Walrasian_equilibrium": ("cross_chapter", "Definition_10.B.5"),
    "competitive_equilibrium": ("cross_chapter", "Definition_10.B.5"),
    "core_equivalence": ("cross_chapter", "Proposition_18.B.1"),
    "Arrow_Debreu": ("cross_chapter", "Proposition_19.D.1"),
}


# ---------------------------------------------------------------------------
# BlockerInfo data class
# ---------------------------------------------------------------------------

@dataclass
class BlockerInfo:
    """Metrics for a single external blocker node."""
    blocker_id: str
    category: str           # "mathlib", "textbook", "economics", "cross_chapter", "unknown"
    direct_dependents: int
    transitive_dependents: int
    chapters_affected: list[int] = field(default_factory=list)
    domains_affected: list[str] = field(default_factory=list)
    blocking_power: float = 0.0
    suggested_source: str = ""
    rank: int = 0


# ---------------------------------------------------------------------------
# Composite score weights
# ---------------------------------------------------------------------------

_WEIGHTS = {
    "transitive": 0.40,
    "direct": 0.25,
    "chapters": 0.20,
    "domains": 0.15,
}


def _composite_score(
    direct: int,
    transitive: int,
    n_chapters: int,
    n_domains: int,
    max_direct: int,
    max_transitive: int,
    max_chapters: int,
    max_domains: int,
) -> float:
    """Compute normalized composite blocking power score in [0, 1]."""
    def _safe_norm(val: int, mx: int) -> float:
        return val / mx if mx > 0 else 0.0

    return (
        _WEIGHTS["transitive"] * _safe_norm(transitive, max_transitive)
        + _WEIGHTS["direct"] * _safe_norm(direct, max_direct)
        + _WEIGHTS["chapters"] * _safe_norm(n_chapters, max_chapters)
        + _WEIGHTS["domains"] * _safe_norm(n_domains, max_domains)
    )


# ---------------------------------------------------------------------------
# Core computation
# ---------------------------------------------------------------------------

def compute_blocker_metrics(graph: DependencyGraph) -> list[BlockerInfo]:
    """Compute blocking-power metrics for all External/axiom-stub nodes.

    Returns a list of BlockerInfo sorted by blocking_power descending.
    """
    from .dependency_graph import NodeType

    # Identify blocker nodes: EXTERNAL type or axiom stubs
    blocker_ids: list[str] = []
    for nid, node in graph.nodes.items():
        if node.node_type == NodeType.EXTERNAL:
            blocker_ids.append(nid)
        elif node.axioms_declared:
            # Items that declare axiom stubs are themselves not blockers,
            # but their axiom stubs are. We track the external refs.
            pass

    if not blocker_ids:
        return []

    # Pre-compute metrics for each blocker
    raw: list[BlockerInfo] = []
    for bid in blocker_ids:
        direct = graph.dependents_of(bid, transitive=False)
        transitive = graph.dependents_of(bid, transitive=True)

        chapters = sorted({
            graph.nodes[d].chapter for d in transitive
            if d in graph.nodes and graph.nodes[d].chapter > 0
        })
        domains = sorted({
            graph.nodes[d].domain.value for d in transitive
            if d in graph.nodes
        })

        # Source lookup
        concept = bid.replace("External:", "")
        cat, source = _SOURCE_MAP.get(concept, ("unknown", ""))

        raw.append(BlockerInfo(
            blocker_id=bid,
            category=cat,
            direct_dependents=len(direct),
            transitive_dependents=len(transitive),
            chapters_affected=chapters,
            domains_affected=domains,
            suggested_source=source,
        ))

    # Compute composite scores
    max_direct = max((b.direct_dependents for b in raw), default=1)
    max_transitive = max((b.transitive_dependents for b in raw), default=1)
    max_chapters = max((len(b.chapters_affected) for b in raw), default=1)
    max_domains = max((len(b.domains_affected) for b in raw), default=1)

    for b in raw:
        b.blocking_power = _composite_score(
            b.direct_dependents, b.transitive_dependents,
            len(b.chapters_affected), len(b.domains_affected),
            max_direct, max_transitive, max_chapters, max_domains,
        )

    # Sort and rank
    raw.sort(key=lambda b: b.blocking_power, reverse=True)
    for i, b in enumerate(raw, 1):
        b.rank = i

    return raw


# ---------------------------------------------------------------------------
# Report formatting
# ---------------------------------------------------------------------------

def format_blocker_report(blockers: list[BlockerInfo], top_k: int = 20) -> str:
    """Format a ranked table of external blockers."""
    lines = [
        f"=== Top-{min(top_k, len(blockers))} External Blockers ===",
        "",
        f"{'Rank':<5} {'Blocker':<45} {'Cat':<13} {'Direct':<7} {'Trans':<7} "
        f"{'Chaps':<8} {'Score':<6} {'Source'}",
        "-" * 120,
    ]
    for b in blockers[:top_k]:
        name = b.blocker_id[:44]
        chaps = ",".join(str(c) for c in b.chapters_affected)
        src = b.suggested_source[:40] if b.suggested_source else "-"
        lines.append(
            f"{b.rank:<5} {name:<45} {b.category:<13} {b.direct_dependents:<7} "
            f"{b.transitive_dependents:<7} {chaps:<8} {b.blocking_power:<6.3f} {src}"
        )

    lines.append("")
    lines.append(f"Total external blockers: {len(blockers)}")

    # Category summary
    cats: dict[str, int] = {}
    for b in blockers:
        cats[b.category] = cats.get(b.category, 0) + 1
    lines.append("\nBy category:")
    for cat, count in sorted(cats.items(), key=lambda x: -x[1]):
        lines.append(f"  {cat}: {count}")

    return "\n".join(lines)


def format_source_recommendations(blockers: list[BlockerInfo]) -> str:
    """Group blockers by source and show aggregate impact."""
    # Group by (category, source)
    groups: dict[tuple[str, str], list[BlockerInfo]] = {}
    for b in blockers:
        key = (b.category, b.suggested_source or "(unmapped)")
        groups.setdefault(key, []).append(b)

    lines = ["=== Source Recommendations (grouped by formalization source) ===", ""]

    for (cat, source), items in sorted(
        groups.items(),
        key=lambda kv: -sum(b.blocking_power for b in kv[1]),
    ):
        total_trans = sum(b.transitive_dependents for b in items)
        total_score = sum(b.blocking_power for b in items)
        lines.append(f"[{cat}] {source}")
        lines.append(f"  Blockers: {len(items)}, total transitive dependents: {total_trans}, "
                      f"aggregate score: {total_score:.3f}")
        for b in sorted(items, key=lambda x: -x.blocking_power):
            lines.append(f"    - {b.blocker_id} (score={b.blocking_power:.3f}, "
                          f"trans={b.transitive_dependents})")
        lines.append("")

    return "\n".join(lines)
