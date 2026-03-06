"""Stage 4: Knowledge Agent — deterministic semantic tagging and dependency extraction.

Replaces LLM-based analysis with regex/string parsing of verified Lean code.
Extracts imports, tactic tags, and domain connections without any Claude calls.
"""

import re

from ..schemas import TheoremInput, StructuredProof, KnowledgeNode, Domain

# Tactic → human-readable method tag
TACTIC_TAG_MAP: dict[str, str] = {
    "by_contra": "contradiction",
    "contradiction": "contradiction",
    "absurd": "contradiction",
    "induction": "induction",
    "cases": "case_analysis",
    "rcases": "case_analysis",
    "obtain": "case_analysis",
    "match": "case_analysis",
    "simp": "simplification",
    "norm_num": "computation",
    "decide": "computation",
    "native_decide": "computation",
    "omega": "arithmetic",
    "linarith": "linear_arithmetic",
    "nlinarith": "nonlinear_arithmetic",
    "ring": "ring_computation",
    "field_simp": "field_simplification",
    "polyrith": "polynomial_arithmetic",
    "exact": "exact_term",
    "apply": "backward_reasoning",
    "refine": "backward_reasoning",
    "intro": "introduction",
    "ext": "extensionality",
    "funext": "function_extensionality",
    "congr": "congruence",
    "gcongr": "generalized_congruence",
    "calc": "calculational_proof",
    "conv": "conversion",
    "rw": "rewriting",
    "simp_rw": "rewriting",
    "push_neg": "negation_push",
    "contrapose": "contraposition",
    "use": "existential_witness",
    "existsi": "existential_witness",
    "constructor": "constructor",
    "left": "disjunction",
    "right": "disjunction",
    "trivial": "trivial",
    "tauto": "tautology",
    "aesop": "automation",
    "positivity": "positivity",
    "mono": "monotonicity",
    "bound_tac": "bound_checking",
    "measurability": "measurability",
    "continuity": "continuity",
    "norm_cast": "cast_normalization",
    "push_cast": "cast_normalization",
}

# Lean module path prefix → Domain mapping
MODULE_DOMAIN_MAP: list[tuple[str, Domain]] = [
    ("Mathlib.MeasureTheory", Domain.MEASURE_THEORY),
    ("Mathlib.Probability", Domain.PROBABILITY),
    ("Mathlib.Topology", Domain.TOPOLOGY),
    ("Mathlib.Analysis", Domain.REAL_ANALYSIS),
    ("Mathlib.Order", Domain.ORDER_THEORY),
    ("Mathlib.Algebra", Domain.ALGEBRA),
    ("Mathlib.GroupTheory", Domain.ALGEBRA),
    ("Mathlib.RingTheory", Domain.ALGEBRA),
    ("Mathlib.FieldTheory", Domain.ALGEBRA),
    ("Mathlib.LinearAlgebra", Domain.ALGEBRA),
    ("Mathlib.NumberTheory", Domain.NUMBER_THEORY),
    ("Mathlib.Combinatorics", Domain.COMBINATORICS),
    ("Mathlib.SetTheory", Domain.SET_THEORY),
    ("Mathlib.Logic", Domain.LOGIC),
    ("Mathlib.Geometry", Domain.GEOMETRY),
    ("Mathlib.CategoryTheory", Domain.ALGEBRA),
    ("Mathlib.Data", Domain.COMBINATORICS),
    ("Mathlib.Tactic", Domain.LOGIC),
]


def _extract_lean_dependencies(lean_code: str) -> list[str]:
    """Extract Lean dependencies from import statements and Mathlib identifiers."""
    deps: list[str] = []
    seen: set[str] = set()

    # Extract import lines
    for m in re.finditer(r"^import\s+([\w.]+)", lean_code, re.MULTILINE):
        dep = m.group(1)
        if dep not in seen:
            deps.append(dep)
            seen.add(dep)

    # Extract Mathlib.X.Y.Z references in the code body (not in imports)
    for m in re.finditer(r"\bMathlib(?:\.\w+)+", lean_code):
        dep = m.group(0)
        if dep not in seen:
            deps.append(dep)
            seen.add(dep)

    # Extract qualified identifiers like Module.Name.theorem used in proofs
    for m in re.finditer(r"\b([A-Z]\w+(?:\.\w+){2,})", lean_code):
        dep = m.group(1)
        if dep not in seen and not dep.startswith("Mathlib"):
            deps.append(dep)
            seen.add(dep)

    return deps


def _extract_tactic_tags(lean_code: str) -> list[str]:
    """Extract method tags from tactics used in the Lean proof."""
    tags: set[str] = set()

    # Look for tactic blocks (after "by" keyword or inside tactic combinators)
    # Scan for known tactic keywords
    for tactic, tag in TACTIC_TAG_MAP.items():
        # Match tactic as a standalone word (not part of a larger identifier)
        pattern = rf"\b{re.escape(tactic)}\b"
        if re.search(pattern, lean_code):
            tags.add(tag)

    # Detect proof style
    if re.search(r"\bcalc\b", lean_code):
        tags.add("calculational_proof")
    if re.search(r":=\s*by\b", lean_code):
        tags.add("tactic_proof")
    if re.search(r":=\s*\{", lean_code) or re.search(r":=\s*⟨", lean_code):
        tags.add("term_proof")
    if re.search(r"\bsorry\b", lean_code):
        tags.add("incomplete")

    return sorted(tags)


def _module_to_domain(module_path: str) -> Domain | None:
    """Map a Lean module path to a mathematical domain."""
    for prefix, domain in MODULE_DOMAIN_MAP:
        if module_path.startswith(prefix):
            return domain
    return None


def _infer_connections(theorem: TheoremInput, lean_deps: list[str]) -> list[str]:
    """Infer semantic cross-domain connections from dependencies."""
    connections: list[str] = []
    seen_domains: set[str] = set()

    for dep in lean_deps:
        domain = _module_to_domain(dep)
        if domain and domain != theorem.domain and domain.value not in seen_domains:
            connections.append(f"{domain.value}: {dep}")
            seen_domains.add(domain.value)

    return connections


class KnowledgeAgent:
    def analyze(
        self,
        theorem: TheoremInput,
        proof: StructuredProof,
        lean_code: str,
    ) -> KnowledgeNode:
        """Build a KnowledgeNode from verified Lean code using deterministic extraction.

        No LLM calls — uses regex parsing of imports, tactics, and module paths.
        """
        lean_deps = _extract_lean_dependencies(lean_code)
        tags = _extract_tactic_tags(lean_code)
        connections = _infer_connections(theorem, lean_deps)

        # Add proof strategy as a tag
        tags_with_strategy = [proof.strategy.value] + tags

        return KnowledgeNode(
            theorem_name=theorem.name,
            domain=theorem.domain,
            tags=tags_with_strategy,
            lean_dependencies=lean_deps,
            semantic_connections=connections,
        )
