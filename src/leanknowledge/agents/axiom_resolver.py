"""Agent 4.5: Axiom Resolver — scans compiled Lean files for axiom declarations
and searches the consolidated Rosetta Stone + Mathlib index for matches.

Two modes:
  1. **Batch** (post-run): Scan all lean files in an output tree, produce a report.
  2. **Inline** (per-item): After a successful compilation, check that single file.

Resolution categories:
  - mathlib_exact:  Axiom signature closely matches a Mathlib declaration.
  - rosetta_exact:  Axiom matches a previously proved MWG theorem in the Rosetta Stone.
  - reference_exact: Axiom directly maps to an extraction dependency ID (via name matching).
  - partial:        Plausible match (score ≥ 0.3) but needs manual review.
  - unresolved:     No match found — economic primitive or genuinely new.

Axiom provenance (inferred from name patterns + extraction dependencies):
  - dependency:   Axiom name maps to an extraction dependency ID.
  - proof_step:   Axiom is a decomposed sub-lemma (step1_, step2_, ...).
  - scaffolding:  Type/function declaration for economic domain primitives.
  - unknown:      Cannot determine provenance.
"""

from __future__ import annotations

import hashlib
import json
import re
from dataclasses import dataclass, field
from enum import Enum
from pathlib import Path

from ..mathlib_index import MathlibIndex, SearchResult
from ..schemas import ExtractedItem, StatementType, ClaimRole


# ---------------------------------------------------------------------------
# Types
# ---------------------------------------------------------------------------

class MatchCategory(str, Enum):
    MATHLIB_EXACT = "mathlib_exact"
    ROSETTA_EXACT = "rosetta_exact"
    REFERENCE_EXACT = "reference_exact"
    PARTIAL = "partial"
    UNRESOLVED = "unresolved"


class AxiomProvenance(str, Enum):
    DEPENDENCY = "dependency"      # maps to an extraction dependency
    PROOF_STEP = "proof_step"      # decomposed sub-lemma (step1_, step2_)
    SCAFFOLDING = "scaffolding"    # type/function for economic primitives
    UNKNOWN = "unknown"


@dataclass
class AxiomDeclaration:
    """A single axiom extracted from a Lean file."""
    name: str              # e.g. "nonneg_zero_at_isLocalMin"
    signature: str         # full declaration after the name (type signature)
    file_path: str         # which .lean file it came from
    item_id: str           # inferred from file name (e.g. "proposition_3.f.1")


@dataclass
class AxiomMatch:
    """Result of searching for a resolution of an axiom."""
    axiom: AxiomDeclaration
    category: MatchCategory
    best_match_name: str = ""
    best_match_score: float = 0.0
    best_match_source: str = ""   # "mathlib", "rosetta", or "reference"
    top_candidates: list[SearchResult] = field(default_factory=list)
    provenance: AxiomProvenance = AxiomProvenance.UNKNOWN
    reference_id: str = ""        # extraction dependency ID if provenance == DEPENDENCY


@dataclass
class ResolutionReport:
    """Summary of a batch scan."""
    total_files: int = 0
    files_with_axioms: int = 0
    total_axioms: int = 0
    mathlib_exact: list[AxiomMatch] = field(default_factory=list)
    rosetta_exact: list[AxiomMatch] = field(default_factory=list)
    reference_exact: list[AxiomMatch] = field(default_factory=list)
    partial: list[AxiomMatch] = field(default_factory=list)
    unresolved: list[AxiomMatch] = field(default_factory=list)

    @property
    def resolvable_count(self) -> int:
        return (len(self.mathlib_exact) + len(self.rosetta_exact)
                + len(self.reference_exact))


# ---------------------------------------------------------------------------
# Axiom extraction
# ---------------------------------------------------------------------------

# Matches `axiom name ...` spanning multiple lines until the next top-level
# declaration or blank line.  Captures name (group 1) and everything after
# the name until the next top-level keyword (group 2).
_AXIOM_BLOCK_RE = re.compile(
    r"^\s*axiom\s+([\w.]+)(.*?)(?=\n\s*(?:axiom|theorem|lemma|def|noncomputable|instance|class|structure|section|namespace|end|open|import|#)|(?:\n\s*\n)|\Z)",
    re.MULTILINE | re.DOTALL,
)


def extract_axioms(lean_code: str, file_path: str = "") -> list[AxiomDeclaration]:
    """Extract all axiom declarations from Lean 4 source code.

    Returns a list of AxiomDeclaration with name, full type signature, and source file.
    """
    # Infer item_id from file name
    item_id = ""
    if file_path:
        item_id = Path(file_path).stem

    results = []
    for m in _AXIOM_BLOCK_RE.finditer(lean_code):
        name = m.group(1)
        sig = m.group(2).strip()
        # Clean up: collapse internal whitespace
        sig = re.sub(r"\s+", " ", sig)
        results.append(AxiomDeclaration(
            name=name,
            signature=sig,
            file_path=file_path,
            item_id=item_id,
        ))
    return results


def extract_axioms_from_file(path: Path) -> list[AxiomDeclaration]:
    """Read a .lean file and extract axiom declarations."""
    try:
        code = path.read_text(encoding="utf-8")
    except Exception:
        return []
    return extract_axioms(code, file_path=str(path))


# ---------------------------------------------------------------------------
# Axiom → ExtractedItem conversion
# ---------------------------------------------------------------------------

# Matches binder variable names: `(x : Type)` → `(_ : Type)`
_BINDER_VAR_RE = re.compile(r"\(\s*\w+\s*:")


def normalize_signature(sig: str) -> str:
    """Strip variable names from binders, collapse whitespace for dedup.

    ``(x : Type)`` and ``(y : Type)`` both become ``(_ : Type)``.
    """
    out = _BINDER_VAR_RE.sub("(_ :", sig)
    out = re.sub(r"\s+", " ", out).strip()
    return out


def signature_hash(sig: str) -> str:
    """SHA-256 hex digest of the normalized signature (for dedup keys)."""
    return hashlib.sha256(normalize_signature(sig).encode("utf-8")).hexdigest()


def axiom_to_item_id(ax: AxiomDeclaration) -> str:
    """Generate a stable item ID for an axiom.

    Named axioms → ``Axiom:<name>``.  Anonymous/generic → ``Axiom:<hash[:12]>``.
    """
    if ax.name and not ax.name.startswith("_"):
        return f"Axiom:{ax.name}"
    return f"Axiom:{signature_hash(ax.signature)[:12]}"


def axiom_to_extracted_item(ax: AxiomDeclaration) -> ExtractedItem:
    """Convert an AxiomDeclaration → ExtractedItem for backlog ingestion."""
    return ExtractedItem(
        id=axiom_to_item_id(ax),
        type=StatementType.AXIOM,
        role=ClaimRole.INVOKED_DEPENDENCY,
        statement=f"axiom {ax.name} {ax.signature}",
        section=ax.item_id or "axiom_stub",
        dependencies=[],
    )


def extract_axiom_items(
    lean_code: str,
    file_path: str = "",
    mathlib_index: MathlibIndex | None = None,
) -> list[ExtractedItem]:
    """Extract axioms from Lean code, filter Mathlib/Rosetta-resolvable, dedup.

    Returns a list of ExtractedItems suitable for backlog ingestion.
    """
    axioms = extract_axioms(lean_code, file_path=file_path)
    items: list[ExtractedItem] = []
    seen_hashes: set[str] = set()
    for ax in axioms:
        # Skip if resolvable against Mathlib/Rosetta
        if mathlib_index:
            match = resolve_axiom(ax, mathlib_index)
            if match.category in (MatchCategory.MATHLIB_EXACT, MatchCategory.ROSETTA_EXACT):
                continue
        # Dedup by signature hash
        h = signature_hash(ax.signature)
        if h in seen_hashes:
            continue
        seen_hashes.add(h)
        items.append(axiom_to_extracted_item(ax))
    return items


# ---------------------------------------------------------------------------
# Reference tagging — extraction dependency matching
# ---------------------------------------------------------------------------

def load_extraction_deps(extraction_path: Path) -> dict[str, list[str]]:
    """Load extraction.json and return a map of item_id → dependency IDs.

    Args:
        extraction_path: Path to extraction.json for a chapter.

    Returns:
        Dict mapping lowercase item_id (matching Lean filenames) to list
        of dependency IDs as they appear in extraction.json.
    """
    if not extraction_path.exists():
        return {}

    try:
        data = json.loads(extraction_path.read_text(encoding="utf-8"))
    except (json.JSONDecodeError, OSError):
        return {}

    items = data if isinstance(data, list) else data.get("items", [])
    deps_map: dict[str, list[str]] = {}
    for item in items:
        item_id = item.get("id", "")
        deps = item.get("dependencies", [])
        if item_id and deps:
            # Lean filenames are lowercase with dots (e.g., proposition_3.f.1)
            key = item_id.lower()
            deps_map[key] = deps
    return deps_map


def _normalize_for_match(s: str) -> str:
    """Normalize a name for fuzzy matching: lowercase, strip separators."""
    return re.sub(r"[_.\-\s]", "", s.lower())


# Detect proof-step axioms (step1_, step2_helper_, etc.)
_STEP_RE = re.compile(r"^step\d+", re.IGNORECASE)

# Detect domain scaffolding (pure type declarations like `axiom Foo : Type`)
_SCAFFOLDING_SIGS = {"Type", "Type*", "Prop", "Type → Type", "Type*→Type*"}


def classify_provenance(
    axiom: AxiomDeclaration,
    dependencies: list[str] | None = None,
) -> tuple[AxiomProvenance, str]:
    """Classify an axiom's provenance and find its reference ID.

    Args:
        axiom: The axiom declaration.
        dependencies: List of extraction dependency IDs for this item.

    Returns:
        (provenance, reference_id) — reference_id is non-empty only for
        DEPENDENCY provenance.
    """
    # Check proof-step pattern first
    if _STEP_RE.match(axiom.name):
        return AxiomProvenance.PROOF_STEP, ""

    # Check if axiom name maps to any extraction dependency
    if dependencies:
        norm_name = _normalize_for_match(axiom.name)
        for dep_id in dependencies:
            norm_dep = _normalize_for_match(dep_id)
            # Direct match: normalized name contains normalized dep ID or vice versa
            if norm_dep in norm_name or norm_name in norm_dep:
                return AxiomProvenance.DEPENDENCY, dep_id
            # Also try matching without common prefixes
            # e.g., dep "Proposition_3.F.1" → "proposition3f1"
            #        axiom "prop_3F1" → "prop3f1"
            dep_short = re.sub(
                r"^(proposition|definition|theorem|lemma|claim|example|remark|implicit_def)",
                "", norm_dep,
            )
            name_short = re.sub(
                r"^(prop|def|thm|lem|claim|ex|rem)",
                "", norm_name,
            )
            if dep_short and name_short and (dep_short in name_short or name_short in dep_short):
                return AxiomProvenance.DEPENDENCY, dep_id

    # Check scaffolding: very short type-only signatures
    sig_stripped = axiom.signature.strip().rstrip("*").strip()
    if sig_stripped in _SCAFFOLDING_SIGS or not axiom.signature.strip():
        return AxiomProvenance.SCAFFOLDING, ""

    return AxiomProvenance.UNKNOWN, ""


# ---------------------------------------------------------------------------
# Resolution logic
# ---------------------------------------------------------------------------

# Thresholds
EXACT_THRESHOLD = 0.55    # TF-IDF scores are lower than embedding scores
PARTIAL_THRESHOLD = 0.30


def resolve_axiom(
    axiom: AxiomDeclaration,
    index: MathlibIndex,
    top_k: int = 5,
    dependencies: list[str] | None = None,
) -> AxiomMatch:
    """Search the index for a match for a single axiom.

    Builds a query from both the axiom name and its signature, searches
    the MathlibIndex, and classifies the best result.

    Args:
        axiom: The axiom to resolve.
        index: MathlibIndex with Mathlib declarations + Rosetta Stone.
        top_k: Number of candidates to return.
        dependencies: Optional extraction dependency IDs for this item.
            Enables reference tagging — direct ID matching in addition
            to TF-IDF similarity.
    """
    # Classify provenance
    provenance, reference_id = classify_provenance(axiom, dependencies)

    # If we have a reference ID, check if it exists in the index (rosetta)
    if reference_id and index.has_name(reference_id):
        return AxiomMatch(
            axiom=axiom,
            category=MatchCategory.REFERENCE_EXACT,
            best_match_name=reference_id,
            best_match_score=1.0,
            best_match_source="reference",
            provenance=provenance,
            reference_id=reference_id,
        )

    # Build query: name (split on dots/underscores for better TF-IDF) + signature
    query = f"{axiom.name.replace('_', ' ').replace('.', ' ')} {axiom.signature}"

    # If we have a reference ID, also add it to boost the query
    if reference_id:
        query = f"{reference_id.replace('_', ' ').replace('.', ' ')} {query}"

    results = index.search(query, top_k=top_k)
    if not results:
        return AxiomMatch(
            axiom=axiom, category=MatchCategory.UNRESOLVED,
            provenance=provenance, reference_id=reference_id,
        )

    best = results[0]

    # Classify
    if best.score >= EXACT_THRESHOLD:
        if best.source == "mathlib":
            cat = MatchCategory.MATHLIB_EXACT
        else:
            cat = MatchCategory.ROSETTA_EXACT
    elif best.score >= PARTIAL_THRESHOLD:
        cat = MatchCategory.PARTIAL
    else:
        cat = MatchCategory.UNRESOLVED

    return AxiomMatch(
        axiom=axiom,
        category=cat,
        best_match_name=best.name,
        best_match_score=best.score,
        best_match_source=best.source,
        top_candidates=results[:top_k],
        provenance=provenance,
        reference_id=reference_id,
    )


# ---------------------------------------------------------------------------
# Batch scan
# ---------------------------------------------------------------------------

def _classify_match(report: ResolutionReport, match: AxiomMatch) -> None:
    """Append a match to the appropriate report bucket."""
    if match.category == MatchCategory.MATHLIB_EXACT:
        report.mathlib_exact.append(match)
    elif match.category == MatchCategory.ROSETTA_EXACT:
        report.rosetta_exact.append(match)
    elif match.category == MatchCategory.REFERENCE_EXACT:
        report.reference_exact.append(match)
    elif match.category == MatchCategory.PARTIAL:
        report.partial.append(match)
    else:
        report.unresolved.append(match)


def scan_directory(
    lean_dir: Path,
    index: MathlibIndex,
    top_k: int = 5,
    extraction_deps: dict[str, list[str]] | None = None,
) -> ResolutionReport:
    """Scan all .lean files in a directory tree and resolve axioms.

    Args:
        lean_dir: Root directory to scan (recursively finds .lean files).
        index: MathlibIndex loaded with Mathlib declarations + Rosetta Stone.
        top_k: Number of candidates to return per axiom.
        extraction_deps: Optional dict of item_id → dependency IDs from
            extraction.json. Enables reference tagging.

    Returns:
        ResolutionReport with categorized matches.
    """
    report = ResolutionReport()

    lean_files = sorted(lean_dir.rglob("*.lean"))
    report.total_files = len(lean_files)

    for lf in lean_files:
        axioms = extract_axioms_from_file(lf)
        if not axioms:
            continue
        report.files_with_axioms += 1
        report.total_axioms += len(axioms)

        # Look up extraction dependencies for this file's item
        item_key = lf.stem.lower()
        deps = (extraction_deps or {}).get(item_key)

        for axiom in axioms:
            match = resolve_axiom(axiom, index, top_k=top_k, dependencies=deps)
            _classify_match(report, match)

    return report


def scan_single_file(
    lean_path: Path,
    index: MathlibIndex,
    top_k: int = 5,
    dependencies: list[str] | None = None,
) -> list[AxiomMatch]:
    """Inline mode: scan a single file and return matches.

    Args:
        lean_path: Path to the .lean file to scan.
        index: MathlibIndex.
        top_k: Number of candidates.
        dependencies: Optional extraction dependency IDs for this item.
    """
    axioms = extract_axioms_from_file(lean_path)
    return [resolve_axiom(ax, index, top_k=top_k, dependencies=dependencies)
            for ax in axioms]


# ---------------------------------------------------------------------------
# Report formatting
# ---------------------------------------------------------------------------

def format_report(report: ResolutionReport) -> str:
    """Format a ResolutionReport as human-readable text."""
    lines = [
        "=" * 60,
        "Axiom Resolution Report",
        "=" * 60,
        f"Files scanned:       {report.total_files}",
        f"Files with axioms:   {report.files_with_axioms}",
        f"Total axioms:        {report.total_axioms}",
        f"Mathlib exact:       {len(report.mathlib_exact)}",
        f"Rosetta exact:       {len(report.rosetta_exact)}",
        f"Reference exact:     {len(report.reference_exact)}",
        f"Partial matches:     {len(report.partial)}",
        f"Unresolved:          {len(report.unresolved)}",
        f"Resolvable:          {report.resolvable_count} / {report.total_axioms}",
        "",
    ]

    # Provenance breakdown
    all_matches = (report.mathlib_exact + report.rosetta_exact
                   + report.reference_exact + report.partial + report.unresolved)
    prov_counts = {}
    for m in all_matches:
        prov_counts[m.provenance.value] = prov_counts.get(m.provenance.value, 0) + 1
    if prov_counts:
        lines.append("--- PROVENANCE BREAKDOWN ---")
        for p in ["dependency", "proof_step", "scaffolding", "unknown"]:
            if prov_counts.get(p, 0) > 0:
                lines.append(f"  {p:20s} {prov_counts[p]}")
        lines.append("")

    if report.mathlib_exact:
        lines.append("--- MATHLIB EXACT MATCHES (can eliminate immediately) ---")
        for m in report.mathlib_exact:
            lines.append(f"  {m.axiom.name}")
            lines.append(f"    -> {m.best_match_name} (score={m.best_match_score:.3f})")
            lines.append(f"    file: {m.axiom.file_path}")
        lines.append("")

    if report.rosetta_exact:
        lines.append("--- ROSETTA EXACT MATCHES (proved elsewhere in MWG) ---")
        for m in report.rosetta_exact:
            lines.append(f"  {m.axiom.name}")
            lines.append(f"    -> {m.best_match_name} (score={m.best_match_score:.3f})")
            lines.append(f"    file: {m.axiom.file_path}")
        lines.append("")

    if report.reference_exact:
        lines.append("--- REFERENCE EXACT (matched to extraction dependency) ---")
        for m in report.reference_exact:
            lines.append(f"  {m.axiom.name}")
            lines.append(f"    -> {m.reference_id} (direct dependency match)")
            lines.append(f"    file: {m.axiom.file_path}")
        lines.append("")

    if report.partial:
        lines.append("--- PARTIAL MATCHES (needs review) ---")
        for m in report.partial:
            lines.append(f"  {m.axiom.name}")
            prov_tag = f" [{m.provenance.value}]" if m.provenance != AxiomProvenance.UNKNOWN else ""
            ref_tag = f" ref={m.reference_id}" if m.reference_id else ""
            lines.append(f"    -> {m.best_match_name} (score={m.best_match_score:.3f}, source={m.best_match_source}){prov_tag}{ref_tag}")
            lines.append(f"    file: {m.axiom.file_path}")
        lines.append("")

    if report.unresolved:
        lines.append(f"--- UNRESOLVED ({len(report.unresolved)} axioms) ---")
        for m in report.unresolved:
            prov_tag = f" [{m.provenance.value}]" if m.provenance != AxiomProvenance.UNKNOWN else ""
            lines.append(f"  {m.axiom.name}  ({m.axiom.file_path}){prov_tag}")
        lines.append("")

    return "\n".join(lines)
