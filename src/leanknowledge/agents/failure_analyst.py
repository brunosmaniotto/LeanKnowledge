"""Agent 7: Failure Analyst — cross-theorem failure analysis and retry.

After a formalization batch, this agent:
  1. Clusters failures by normalized error pattern
  2. Generates corrective lessons per cluster (templates + optional LLM)
  3. Selects items for retry with enriched context

Lessons are injected into the PromptTuner so that retry attempts benefit
from cross-theorem analysis without any translator signature changes.
"""

import json
import os
import re
from dataclasses import dataclass, field
from pathlib import Path

from ..lean.errors import classify_error, parse_compiler_output
from ..schemas import ErrorCategory


# ---------------------------------------------------------------------------
# Configuration
# ---------------------------------------------------------------------------

MAX_RETRY_CYCLES = int(os.environ.get("LK_RETRY_MAX_CYCLES", "2"))

# Retry budget (reduced — items already exhausted 16 attempts)
RETRY_DIRECT_ATTEMPTS = int(os.environ.get("LK_RETRY_DIRECT_ATTEMPTS", "2"))
RETRY_TIER1_ATTEMPTS = int(os.environ.get("LK_RETRY_TIER1_ATTEMPTS", "3"))
RETRY_TIER2_ATTEMPTS = int(os.environ.get("LK_RETRY_TIER2_ATTEMPTS", "2"))

# How many prior triples to carry forward as context
RETRY_CONTEXT_TRIPLES = int(os.environ.get("LK_RETRY_CONTEXT_TRIPLES", "3"))

PROMPT_PATH = Path(__file__).resolve().parents[3] / "prompts" / "failure_analyst.md"


# ---------------------------------------------------------------------------
# Data classes
# ---------------------------------------------------------------------------

@dataclass
class FailureCluster:
    """A group of failed items sharing the same error pattern."""
    cluster_id: str
    error_category: ErrorCategory
    normalized_key: str
    count: int
    affected_items: list[str]
    example_errors: list[str] = field(default_factory=list)


@dataclass
class FailureLesson:
    """Actionable corrective text for a failure cluster."""
    cluster_id: str
    severity: str  # "high", "medium", "low"
    lesson_text: str
    affected_items: list[str] = field(default_factory=list)


@dataclass
class AnalysisReport:
    """Full output of failure analysis."""
    clusters: list[FailureCluster]
    lessons: list[FailureLesson]
    retry_items: list[str]
    skip_items: list[str]
    cycle: int = 0

    def to_dict(self) -> dict:
        return {
            "cycle": self.cycle,
            "clusters": [
                {
                    "cluster_id": c.cluster_id,
                    "error_category": c.error_category.value,
                    "normalized_key": c.normalized_key,
                    "count": c.count,
                    "affected_items": c.affected_items,
                    "example_errors": c.example_errors[:3],
                }
                for c in self.clusters
            ],
            "lessons": [
                {
                    "cluster_id": l.cluster_id,
                    "severity": l.severity,
                    "lesson_text": l.lesson_text,
                    "affected_items": l.affected_items,
                }
                for l in self.lessons
            ],
            "retry_items": self.retry_items,
            "skip_items": self.skip_items,
        }


# ---------------------------------------------------------------------------
# Lesson templates per ErrorCategory
# ---------------------------------------------------------------------------

_LESSON_TEMPLATES: dict[ErrorCategory, str] = {
    ErrorCategory.TYPE_MISMATCH: (
        "Multiple theorems failed with type mismatches. Common fixes:\n"
        "- Pick ONE numeric type (ℕ, ℤ, ℝ) and cast everything at the start\n"
        "- Use `push_cast` to push casts inward, `norm_cast` to normalize\n"
        "- For ℕ division: cast to ℤ or ℚ first, prove there, then cast back\n"
        "- `exact_mod_cast h` applies `h` modulo cast normalization\n"
        "- Key lemmas: `Nat.cast_add`, `Nat.cast_mul`, `Int.cast_add`"
    ),
    ErrorCategory.MISSING_LEMMA: (
        "Multiple theorems referenced non-existent Mathlib identifiers. Fixes:\n"
        "- Do NOT guess lemma names — use `exact?`, `apply?`, or `search_proof?`\n"
        "- Check the namespace: `Nat.add_comm` not `add_comm` (or `open Nat`)\n"
        "- Hallucinated identifiers: {hallucinated_names}\n"
        "- Use `import Mathlib` (safe default) rather than guessing module paths"
    ),
    ErrorCategory.TACTIC: (
        "Multiple theorems had tactic failures. Fixes:\n"
        "- If `simp` fails, try `simp only [lemma1, lemma2]` with explicit lemmas\n"
        "- If `omega` fails, the goal may not be linear arithmetic — try `linarith` or `norm_num`\n"
        "- For unsolved goals, decompose with `constructor`, `intro`, or `rcases`\n"
        "- Use `ring` for polynomial equalities, `field_simp` before `ring` for fractions"
    ),
    ErrorCategory.SYNTAX: (
        "Multiple theorems had Lean 4 syntax errors. Fixes:\n"
        "- NEVER use Lean 3 syntax: `∑ i in s` → `∑ i ∈ s`\n"
        "- Use `by` tactic blocks, not term-mode proofs for complex goals\n"
        "- Check parentheses and binder annotations carefully\n"
        "- `open BigOperators` for `∑`/`∏`, `open Finset` for `range`"
    ),
    ErrorCategory.UNKNOWN: (
        "Some theorems failed with unclassified errors. General advice:\n"
        "- Start simple: `import Mathlib`, `open BigOperators Finset`\n"
        "- Use `exact?` and `apply?` to find closing lemmas\n"
        "- Prefer automation: `omega`, `norm_num`, `simp`, `linarith`"
    ),
}


# ---------------------------------------------------------------------------
# Failure Analyst
# ---------------------------------------------------------------------------

class FailureAnalyst:
    """Agent 7: cross-theorem failure analysis and retry selection."""

    def analyze(
        self,
        failed_entries: list,  # list[BacklogEntry]
        output_dir: Path,
        cycle: int = 0,
        use_llm: bool = False,
    ) -> AnalysisReport:
        """Run full failure analysis: cluster → lesson → retry selection.

        Args:
            failed_entries: BacklogEntry objects with status=FAILED
            output_dir: pipeline output dir (for loading triples)
            cycle: current retry cycle number
            use_llm: whether to use LLM for enhanced lesson generation

        Returns:
            AnalysisReport with clusters, lessons, and retry/skip lists.
        """
        # Phase 1: cluster failures
        clusters = self._cluster_failures(failed_entries, output_dir)

        # Phase 2: generate lessons
        lessons = self._generate_lessons(clusters, output_dir, use_llm=use_llm)

        # Phase 3: select retries
        retry_items, skip_items = self._select_retries(
            failed_entries, clusters, cycle,
        )

        return AnalysisReport(
            clusters=clusters,
            lessons=lessons,
            retry_items=retry_items,
            skip_items=skip_items,
            cycle=cycle,
        )

    # ------------------------------------------------------------------
    # Phase 1: Cluster failures
    # ------------------------------------------------------------------

    def _cluster_failures(
        self,
        failed_entries: list,
        output_dir: Path,
    ) -> list[FailureCluster]:
        """Group failures by (error_category, normalized_key)."""
        # Collect all compiler errors per item
        item_errors: dict[str, list[str]] = {}
        triples_dir = output_dir / "triples"
        failures_dir = output_dir / "failures"

        for entry in failed_entries:
            item_id = entry.item.id
            errors = []

            # Try triples first (detailed per-attempt data)
            if triples_dir.exists():
                safe = item_id.lower().replace(" ", "_").replace("/", "_")
                for path in sorted(triples_dir.glob(f"{safe}_*.json")):
                    try:
                        data = json.loads(path.read_text(encoding="utf-8"))
                        for t in data:
                            if not t.get("compiled") and t.get("compiler_output"):
                                errors.append(t["compiler_output"])
                    except (json.JSONDecodeError, OSError):
                        continue

            # Fallback to failure record
            if not errors and failures_dir.exists():
                safe = item_id.lower().replace(" ", "_").replace("/", "_")
                fpath = failures_dir / f"{safe}.json"
                if fpath.exists():
                    try:
                        record = json.loads(fpath.read_text(encoding="utf-8"))
                        if record.get("last_compiler_error"):
                            errors.append(record["last_compiler_error"])
                        elif record.get("error"):
                            errors.append(record["error"])
                    except (json.JSONDecodeError, OSError):
                        pass

            if errors:
                item_errors[item_id] = errors

        # Classify and normalize errors, then group
        buckets: dict[tuple[str, str], list[tuple[str, str]]] = {}
        # key: (category_value, normalized_key), value: list of (item_id, raw_error)

        for item_id, errors in item_errors.items():
            for err_text in errors:
                parsed = parse_compiler_output(err_text)
                if not parsed:
                    # Raw error text
                    category = classify_error(err_text)
                    norm_key = self._normalize_error(err_text)
                    key = (category.value, norm_key)
                    buckets.setdefault(key, []).append((item_id, err_text))
                else:
                    for cerr in parsed:
                        norm_key = self._normalize_error(cerr.message)
                        key = (cerr.category.value, norm_key)
                        buckets.setdefault(key, []).append((item_id, cerr.message))

        # Build clusters (minimum size 2)
        clusters = []
        for (cat_val, norm_key), entries in sorted(
            buckets.items(), key=lambda x: -len(x[1])
        ):
            affected = sorted(set(item_id for item_id, _ in entries))
            if len(affected) < 2:
                continue
            example_errors = list(dict.fromkeys(err for _, err in entries))[:5]
            cluster_id = f"{cat_val}:{norm_key[:60]}"
            clusters.append(FailureCluster(
                cluster_id=cluster_id,
                error_category=ErrorCategory(cat_val),
                normalized_key=norm_key,
                count=len(affected),
                affected_items=affected,
                example_errors=example_errors,
            ))

        return clusters

    @staticmethod
    def _normalize_error(message: str) -> str:
        """Normalize an error message for clustering.

        Strips file paths, line numbers, specific identifiers, and
        whitespace to produce a stable key for grouping.
        """
        # Strip file path prefixes
        norm = re.sub(r"[A-Za-z]:?[/\\][\w/\\._-]+\.lean:\d+:\d+:\s*", "", message)
        # Strip line:col references
        norm = re.sub(r"\d+:\d+:", "", norm)
        # Strip specific identifier names (backtick-quoted)
        norm = re.sub(r"`[^`]+`", "`ID`", norm)
        # Collapse whitespace
        norm = re.sub(r"\s+", " ", norm).strip()
        # Take first line only
        norm = norm.split("\n")[0][:120]
        return norm

    # ------------------------------------------------------------------
    # Phase 2: Generate lessons
    # ------------------------------------------------------------------

    def _generate_lessons(
        self,
        clusters: list[FailureCluster],
        output_dir: Path,
        use_llm: bool = False,
    ) -> list[FailureLesson]:
        """Generate corrective lessons from failure clusters."""
        lessons = []

        for cluster in clusters:
            # Deterministic template-based lesson
            template = _LESSON_TEMPLATES.get(
                cluster.error_category,
                _LESSON_TEMPLATES[ErrorCategory.UNKNOWN],
            )

            # Fill in template variables
            lesson_text = template
            if "{hallucinated_names}" in lesson_text:
                # Extract hallucinated identifiers from example errors
                names = self._extract_hallucinated_names(cluster.example_errors)
                if names:
                    lesson_text = lesson_text.replace(
                        "{hallucinated_names}",
                        ", ".join(f"`{n}`" for n in names[:10]),
                    )
                else:
                    lesson_text = lesson_text.replace(
                        "{hallucinated_names}",
                        "(could not extract specific names)",
                    )

            severity = "high" if cluster.count >= 3 else "medium"

            lessons.append(FailureLesson(
                cluster_id=cluster.cluster_id,
                severity=severity,
                lesson_text=lesson_text,
                affected_items=cluster.affected_items,
            ))

        # LLM-enhanced path for top clusters
        if use_llm and clusters:
            llm_lessons = self._generate_llm_lessons(clusters[:5])
            lessons.extend(llm_lessons)

        return lessons

    @staticmethod
    def _extract_hallucinated_names(errors: list[str]) -> list[str]:
        """Extract identifier names from 'unknown constant/identifier' errors."""
        names = []
        for err in errors:
            # Match patterns like: unknown constant `Foo.bar`
            matches = re.findall(r"unknown (?:constant|identifier|namespace)\s+[`']([^`']+)[`']", err, re.IGNORECASE)
            names.extend(matches)
            # Also match: not found `Foo.bar`
            matches = re.findall(r"[`']([A-Z][a-zA-Z0-9_.]+)[`'].*not found", err, re.IGNORECASE)
            names.extend(matches)
        return list(dict.fromkeys(names))  # dedupe preserving order

    def _generate_llm_lessons(
        self,
        clusters: list[FailureCluster],
    ) -> list[FailureLesson]:
        """Use LLM to generate root-cause analysis for top clusters."""
        try:
            from ..llm import complete
        except ImportError:
            return []

        # Load system prompt
        system = ""
        if PROMPT_PATH.exists():
            system = PROMPT_PATH.read_text(encoding="utf-8")

        # Build user message from cluster data
        user_parts = ["Analyze these failure clusters and provide specific Lean 4 advice:\n"]
        for i, cluster in enumerate(clusters, 1):
            user_parts.append(f"\n## Cluster {i}: {cluster.error_category.value} ({cluster.count} items)")
            user_parts.append(f"Normalized pattern: {cluster.normalized_key}")
            for ex in cluster.example_errors[:3]:
                user_parts.append(f"```\n{ex[:300]}\n```")

        user_msg = "\n".join(user_parts)

        try:
            response = complete(
                model=os.environ.get("LK_FAILURE_ANALYST_MODEL", "anthropic/claude-sonnet-4-20250514"),
                system=system,
                messages=[{"role": "user", "content": user_msg}],
                max_tokens=2048,
                temperature=0.3,
            )
        except Exception:
            return []

        if not response:
            return []

        # Wrap the LLM response as a single lesson
        return [FailureLesson(
            cluster_id="llm_analysis",
            severity="high",
            lesson_text=response,
            affected_items=[
                item for c in clusters for item in c.affected_items
            ],
        )]

    # ------------------------------------------------------------------
    # Phase 3: Select retries
    # ------------------------------------------------------------------

    def _select_retries(
        self,
        failed_entries: list,
        clusters: list[FailureCluster],
        cycle: int,
    ) -> tuple[list[str], list[str]]:
        """Decide which failed items to retry vs skip.

        Skip:
          - Items with cause="crash" (infrastructure failure, not proof)
          - Items with FUNDAMENTAL errors only
          - Items that have exceeded MAX_RETRY_CYCLES

        Retry:
          - Items whose dominant error has a generated lesson
          - Always retry: OPERATIONAL-cause failures
        """
        # Build set of items that have a lesson
        items_with_lessons: set[str] = set()
        for cluster in clusters:
            items_with_lessons.update(cluster.affected_items)

        retry = []
        skip = []

        for entry in failed_entries:
            item_id = entry.item.id
            retry_count = getattr(entry, "retry_count", 0)

            # Skip if already retried too many times
            if retry_count >= MAX_RETRY_CYCLES:
                skip.append(item_id)
                continue

            # Skip if this is past the allowed cycles
            if cycle >= MAX_RETRY_CYCLES:
                skip.append(item_id)
                continue

            # Check failure cause from the failure_reason
            reason = entry.failure_reason or ""

            # Always skip crashes (infrastructure, not proof)
            if "crash" in reason.lower() and "compilation" not in reason.lower():
                skip.append(item_id)
                continue

            # Check if all errors are FUNDAMENTAL
            if self._is_only_fundamental(reason):
                skip.append(item_id)
                continue

            # Retry if there's a lesson for this item or it's an operational failure
            if item_id in items_with_lessons:
                retry.append(item_id)
            elif self._is_operational(reason):
                retry.append(item_id)
            else:
                # No lesson and not operational — still retry if we have budget
                retry.append(item_id)

        return retry, skip

    @staticmethod
    def _is_only_fundamental(reason: str) -> bool:
        """Check if the failure reason indicates only FUNDAMENTAL errors."""
        # FUNDAMENTAL is a special category — the proof strategy itself is wrong
        if not reason:
            return False
        cat = classify_error(reason)
        return cat == ErrorCategory.FUNDAMENTAL

    @staticmethod
    def _is_operational(reason: str) -> bool:
        """Check if the failure reason indicates an operational issue."""
        lower = reason.lower() if reason else ""
        operational_markers = [
            "empty or vacuous code",
            "unexpected end of input",
            "object file.*does not exist",
            "compilation timed out",
            "unknown module prefix",
        ]
        return any(re.search(pat, lower) for pat in operational_markers)


# ---------------------------------------------------------------------------
# Retry context builder
# ---------------------------------------------------------------------------

def build_retry_context(
    item_id: str,
    output_dir: Path,
    lessons: list[FailureLesson],
    max_triples: int = RETRY_CONTEXT_TRIPLES,
) -> str:
    """Build enriched context for a retry attempt.

    Includes:
      - Last N triples from the original run
      - Applicable failure lessons

    Returns a text block to inject into the translator prompt.
    """
    parts = []

    # 1. Applicable lessons
    item_lessons = [l for l in lessons if item_id in l.affected_items]
    if item_lessons:
        parts.append("## Cross-theorem failure analysis (from batch diagnostics)\n")
        for lesson in item_lessons:
            parts.append(f"### [{lesson.severity.upper()}] {lesson.cluster_id}")
            parts.append(lesson.lesson_text)
            parts.append("")

    # 2. Last N triples from original run
    triples_dir = output_dir / "triples"
    if triples_dir.exists():
        safe = item_id.lower().replace(" ", "_").replace("/", "_")
        triple_files = sorted(triples_dir.glob(f"{safe}_*.json"))
        if triple_files:
            # Load the most recent triple file
            try:
                data = json.loads(triple_files[-1].read_text(encoding="utf-8"))
                # Take last N triples
                recent = data[-max_triples:] if len(data) > max_triples else data
                if recent:
                    parts.append("## Previous attempts (last {} from original run)\n".format(
                        len(recent)
                    ))
                    for i, t in enumerate(recent, 1):
                        parts.append(f"### Attempt {i}")
                        if t.get("compiler_output"):
                            parts.append(f"Error: {t['compiler_output'][:300]}")
                        if t.get("lean_code"):
                            parts.append(f"```lean\n{t['lean_code'][:500]}\n```")
                        parts.append("")
            except (json.JSONDecodeError, OSError):
                pass

    return "\n".join(parts)
