"""Strategy Knowledge Base — learns from verified proofs to guide future translations.

Extracts proof profiles from successful Lean compilations and provides
strategy hints to the translator based on domain, mathematical objects,
and past success patterns.
"""

import json
import re
from dataclasses import dataclass, field, asdict
from pathlib import Path


# ---------------------------------------------------------------------------
# Tactic → human-readable tag mapping
# ---------------------------------------------------------------------------

TACTIC_TAGS: dict[str, str] = {
    "by_contra": "contradiction",
    "by_contradiction": "contradiction",
    "calc": "calculational_proof",
    "induction": "induction",
    "simp": "simplification",
    "linarith": "linear_arithmetic",
    "omega": "arithmetic",
    "rcases": "case_analysis",
    "obtain": "case_analysis",
    "ext": "extensionality",
    "norm_num": "numeric_normalization",
    "ring": "ring_algebra",
    "field_simp": "field_simplification",
    "nlinarith": "nonlinear_arithmetic",
    "exact?": "search",
    "apply?": "search",
    "decide": "decidability",
    "aesop": "automation",
    "positivity": "positivity",
    "gcongr": "congruence",
    "conv": "conversion",
    "rfl": "reflexivity",
    "contradiction": "contradiction",
    "trivial": "trivial",
    "tauto": "propositional_logic",
    "push_neg": "negation",
    "norm_cast": "cast_normalization",
}


def _extract_tactics(lean_code: str) -> list[str]:
    """Extract Lean tactics used in code."""
    tactics = []
    for tactic in TACTIC_TAGS:
        # Match tactic as a word boundary
        if re.search(rf"\b{re.escape(tactic)}\b", lean_code):
            tactics.append(tactic)
    return tactics


def _extract_tactic_tags(lean_code: str) -> list[str]:
    """Map tactics to human-readable tags."""
    return list({TACTIC_TAGS[t] for t in _extract_tactics(lean_code) if t in TACTIC_TAGS})


def _extract_lean_deps(lean_code: str) -> list[str]:
    """Extract Lean declarations referenced (qualified names after exact/apply/rw/simp)."""
    deps = set()
    for m in re.finditer(r"(?:exact|apply|rw|simp\s*\[)\s*([A-Z][\w.]*)", lean_code):
        deps.add(m.group(1))
    return sorted(deps)


def _extract_math_objects(statement: str) -> list[str]:
    """Extract mathematical objects/concepts from a natural-language statement."""
    objects = []
    # Common math concept patterns
    patterns = [
        r"\b(group|ring|field|module|algebra|lattice|monoid|semigroup)\b",
        r"\b(topology|topological|compact|open|closed|continuous|connected)\b",
        r"\b(metric|normed|Banach|Hilbert)\b",
        r"\b(measure|measurable|integrable|probability)\b",
        r"\b(linear|bilinear|multilinear|affine)\b",
        r"\b(finite|infinite|countable|uncountable)\b",
        r"\b(prime|divisible|coprime|gcd|lcm)\b",
        r"\b(sequence|series|convergent|divergent|limit)\b",
        r"\b(function|morphism|homomorphism|isomorphism|endomorphism)\b",
        r"\b(set|subset|union|intersection|complement)\b",
        r"\b(order|partial order|total order|well-order|lattice)\b",
        r"\b(vector|matrix|determinant|eigenvalue|eigenvector)\b",
        r"\b(polynomial|rational|real|complex|integer|natural)\b",
        r"\b(convex|concave|quasi-convex|quasi-concave)\b",
        r"\b(utility|preference|equilibrium|optimization|constraint)\b",
    ]
    for pat in patterns:
        for m in re.finditer(pat, statement, re.IGNORECASE):
            objects.append(m.group(0).lower())
    return sorted(set(objects))


# ---------------------------------------------------------------------------
# Data structures
# ---------------------------------------------------------------------------

@dataclass
class ProofProfile:
    """Record from one successful formalization."""
    theorem_id: str
    domain: str = ""
    mathematical_objects: list[str] = field(default_factory=list)
    proof_strategies: list[str] = field(default_factory=list)
    lean_tactics_used: list[str] = field(default_factory=list)
    lean_tactics_failed: list[str] = field(default_factory=list)
    difficulty: str = "medium"
    iterations_to_compile: int = 1
    error_types_encountered: list[str] = field(default_factory=list)
    dependencies_used: list[str] = field(default_factory=list)


def extract_proof_profile(
    lean_code: str,
    theorem_id: str,
    domain: str = "",
    triples: list[dict] | None = None,
) -> ProofProfile:
    """Extract a ProofProfile from verified Lean code and attempt history."""
    tactics_used = _extract_tactics(lean_code)
    tactic_tags = _extract_tactic_tags(lean_code)
    deps = _extract_lean_deps(lean_code)

    # Analyze attempt history
    triples = triples or []
    total_attempts = len(triples)
    failed_tactics: set[str] = set()
    error_types: list[str] = []

    for t in triples:
        if not t.get("compiled"):
            # Extract tactics from failed code
            failed_code = t.get("lean_code", "")
            if failed_code:
                for tac in _extract_tactics(failed_code):
                    if tac not in tactics_used:
                        failed_tactics.add(tac)
            # Collect error types
            err = t.get("compiler_output", "")
            if err:
                if "unknown identifier" in err or "Unknown constant" in err:
                    error_types.append("hallucinated_identifier")
                elif "unexpected token" in err:
                    error_types.append("parse_error")
                elif "unsolved goals" in err.lower():
                    error_types.append("unsolved_goals")
                elif "type mismatch" in err:
                    error_types.append("type_mismatch")

    # Difficulty based on attempt count
    if total_attempts <= 1:
        difficulty = "easy"
    elif total_attempts <= 5:
        difficulty = "medium"
    else:
        difficulty = "hard"

    return ProofProfile(
        theorem_id=theorem_id,
        domain=domain,
        mathematical_objects=_extract_math_objects(""),  # caller can enrich
        proof_strategies=tactic_tags,
        lean_tactics_used=tactics_used,
        lean_tactics_failed=sorted(failed_tactics),
        difficulty=difficulty,
        iterations_to_compile=total_attempts,
        error_types_encountered=sorted(set(error_types)),
        dependencies_used=deps,
    )


# ---------------------------------------------------------------------------
# Strategy Knowledge Base
# ---------------------------------------------------------------------------

class StrategyKB:
    """Accumulates proof profiles and provides strategy hints for new theorems."""

    def __init__(self) -> None:
        self._profiles: list[ProofProfile] = []

    @property
    def size(self) -> int:
        return len(self._profiles)

    def add(self, profile: ProofProfile) -> None:
        self._profiles.append(profile)

    def save(self, path: Path | str) -> None:
        path = Path(path)
        path.parent.mkdir(parents=True, exist_ok=True)
        with open(path, "w", encoding="utf-8") as f:
            json.dump([asdict(p) for p in self._profiles], f, indent=2)

    def load(self, path: Path | str) -> None:
        path = Path(path)
        if not path.exists():
            return
        with open(path, encoding="utf-8") as f:
            data = json.load(f)
        self._profiles = [ProofProfile(**d) for d in data]

    def query(
        self,
        domain: str = "",
        mathematical_objects: list[str] | None = None,
        top_k: int = 5,
    ) -> list[ProofProfile]:
        """Find relevant profiles by domain and mathematical objects."""
        scored: list[tuple[float, ProofProfile]] = []
        objects = set(o.lower() for o in (mathematical_objects or []))

        for p in self._profiles:
            score = 0.0
            if domain and p.domain == domain:
                score += 2.0
            if objects:
                overlap = objects & set(p.mathematical_objects)
                if overlap:
                    score += len(overlap)
            if score > 0:
                scored.append((score, p))

        scored.sort(key=lambda x: -x[0])
        return [p for _, p in scored[:top_k]]

    def format_strategy_hints(
        self,
        domain: str = "",
        mathematical_objects: list[str] | None = None,
        statement: str = "",
        top_k: int = 3,
    ) -> str:
        """Format strategy hints for the translator prompt."""
        # Also extract objects from statement
        stmt_objects = _extract_math_objects(statement)
        all_objects = list(set((mathematical_objects or []) + stmt_objects))

        profiles = self.query(domain=domain, mathematical_objects=all_objects, top_k=top_k)
        if not profiles:
            return ""

        lines = ["## Strategy hints from similar proofs\n"]
        for p in profiles:
            tactics = ", ".join(p.lean_tactics_used[:5]) if p.lean_tactics_used else "none recorded"
            tags = ", ".join(p.proof_strategies[:3]) if p.proof_strategies else ""
            diff = p.difficulty
            lines.append(f"- **{p.theorem_id}** ({p.domain}, {diff}): tactics [{tactics}]")
            if tags:
                lines.append(f"  Strategies: {tags}")
            if p.lean_tactics_failed:
                failed = ", ".join(p.lean_tactics_failed[:3])
                lines.append(f"  Avoid: [{failed}] (failed in prior attempts)")

        return "\n".join(lines)


# ---------------------------------------------------------------------------
# Build from Rosetta Stone corpus
# ---------------------------------------------------------------------------

def build_from_rosetta(
    rosetta_path: Path | str,
    triples_dir: Path | str | None = None,
) -> StrategyKB:
    """Build a StrategyKB from a rosetta_stone.jsonl file and optional triples."""
    kb = StrategyKB()
    rosetta_path = Path(rosetta_path)

    # Load triples by theorem_id for enrichment
    triples_by_id: dict[str, list[dict]] = {}
    if triples_dir:
        triples_dir = Path(triples_dir)
        if triples_dir.exists():
            for tf in triples_dir.glob("*.json"):
                try:
                    with open(tf, encoding="utf-8") as f:
                        data = json.load(f)
                    tid = data.get("theorem_id", tf.stem)
                    if isinstance(data.get("triples"), list):
                        triples_by_id[tid] = data["triples"]
                except (json.JSONDecodeError, KeyError):
                    continue

    with open(rosetta_path, encoding="utf-8") as f:
        for line in f:
            line = line.strip()
            if not line:
                continue
            try:
                entry = json.loads(line)
            except json.JSONDecodeError:
                continue

            theorem_id = entry.get("id", entry.get("theorem_id", ""))
            lean_code = entry.get("lean_code", "")
            domain = entry.get("domain", entry.get("category", ""))

            if not lean_code:
                continue

            triples = triples_by_id.get(theorem_id, [])
            profile = extract_proof_profile(
                lean_code=lean_code,
                theorem_id=theorem_id,
                domain=domain,
                triples=triples,
            )
            kb.add(profile)

    return kb
