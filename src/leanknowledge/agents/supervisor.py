"""Agent 7: Supervisor — analyzes run results and identifies error patterns.

Reads all output data from a parallel or single-worker run and produces
a structured report with actionable intelligence about what's failing
and why.

Five analysis phases:
  Phase 1 (Run Summary): success rate, attempts per success, per-worker stats
  Phase 2 (Error Classification): categorize and rank compiler errors
  Phase 3 (Identifier Analysis): hallucinated vs. confirmed identifiers
  Phase 4 (Failure Deep-Dive): LLM-powered root cause analysis (optional)
  Phase 5 (Recommendations): ranked improvement suggestions

Phases 1-3 are deterministic (no LLM). Phase 4 requires --llm flag.
Phase 5 is heuristic, derived from Phase 2-3 data.
"""

import json
import re
from collections import Counter
from dataclasses import dataclass, field
from datetime import datetime
from pathlib import Path

from ..lean.errors import classify_error, parse_compiler_output
from ..prompt_tuner import _extract_identifiers
from ..schemas import ErrorCategory


# ---------------------------------------------------------------------------
# Report data structures
# ---------------------------------------------------------------------------

@dataclass
class WorkerStats:
    """Per-worker statistics."""
    worker_id: int | str
    total: int = 0
    successes: int = 0
    failures: int = 0
    total_attempts: int = 0
    avg_attempts_per_success: float = 0.0


@dataclass
class RunSummary:
    """Phase 1: high-level run statistics."""
    total_theorems: int = 0
    successes: int = 0
    failures: int = 0
    success_rate: float = 0.0
    total_attempts: int = 0
    avg_attempts_per_success: float = 0.0
    avg_attempts_per_theorem: float = 0.0
    elapsed_seconds: float = 0.0
    workers: list[WorkerStats] = field(default_factory=list)


@dataclass
class ErrorBucket:
    """A group of similar errors."""
    category: str
    normalized_message: str
    count: int
    example_full_message: str = ""
    example_code_snippet: str = ""
    affected_theorems: list[str] = field(default_factory=list)


@dataclass
class ErrorBreakdown:
    """Phase 2: error classification results."""
    category_counts: dict[str, int] = field(default_factory=dict)
    top_errors: list[ErrorBucket] = field(default_factory=list)
    total_error_instances: int = 0
    errors_per_failed_theorem: float = 0.0


@dataclass
class IdentifierAnalysis:
    """Phase 3: hallucinated vs. confirmed identifier analysis."""
    total_hallucinated: int = 0
    unique_hallucinated: int = 0
    top_hallucinated: list[tuple[str, int]] = field(default_factory=list)
    total_confirmed: int = 0
    unique_confirmed: int = 0
    top_confirmed: list[tuple[str, int]] = field(default_factory=list)
    near_misses: list[tuple[str, str, int]] = field(default_factory=list)


@dataclass
class FailureAnalysis:
    """Phase 4: per-theorem failure analysis."""
    theorem_id: str
    num_attempts: int = 0
    error_categories: list[str] = field(default_factory=list)
    root_cause: str = ""
    last_error_snippet: str = ""


@dataclass
class Recommendation:
    """Phase 5: actionable improvement suggestion."""
    rank: int
    title: str
    description: str
    estimated_impact_pct: float  # estimated % of failures this would fix
    effort: str  # "low", "medium", "high"
    affected_count: int = 0


@dataclass
class RunReport:
    """Complete supervisor report."""
    run_dir: str
    timestamp: str
    summary: RunSummary
    error_breakdown: ErrorBreakdown
    identifier_analysis: IdentifierAnalysis
    failure_analysis: list[FailureAnalysis]
    recommendations: list[Recommendation]

    def to_dict(self) -> dict:
        """Convert to JSON-serializable dict."""
        import dataclasses
        return dataclasses.asdict(self)


# ---------------------------------------------------------------------------
# Supervisor agent
# ---------------------------------------------------------------------------

class Supervisor:
    """Analyzes run output directories and produces structured reports.

    Usage:
        supervisor = Supervisor(Path("outputs/run6_parallel"))
        report = supervisor.analyze(use_llm=False)
        supervisor.print_report(report)
        supervisor.save_report(report, Path("outputs/run6_parallel/report.json"))
    """

    def __init__(self, run_dir: Path):
        self.run_dir = Path(run_dir)
        self._triples: list[dict] = []           # all triples across workers
        self._triple_sources: dict[str, str] = {} # triple file -> theorem id
        self._worker_dirs: list[Path] = []
        self._confirmed_idents: Counter = Counter()
        self._log_texts: dict[int | str, str] = {}

    # ------------------------------------------------------------------
    # Data loading
    # ------------------------------------------------------------------

    def _discover_workers(self) -> list[Path]:
        """Find worker subdirectories or treat run_dir as a single worker."""
        workers = sorted(
            [d for d in self.run_dir.iterdir()
             if d.is_dir() and d.name.startswith("worker_")],
            key=lambda p: p.name,
        )
        if workers:
            return workers
        # Single-worker run: output dir is the worker
        return [self.run_dir]

    def _load_triples(self) -> list[dict]:
        """Load all triple JSON files from all workers."""
        all_triples = []
        for worker_dir in self._worker_dirs:
            triples_dir = worker_dir / "triples"
            if not triples_dir.exists():
                continue
            for path in sorted(triples_dir.glob("*.json")):
                try:
                    data = json.loads(path.read_text(encoding="utf-8"))
                    if isinstance(data, list):
                        # Extract theorem ID from filename
                        # Format: theorem_name_YYYYMMDD_HHMMSS.json
                        stem = path.stem
                        # Strip the timestamp suffix (_YYYYMMDD_HHMMSS)
                        theorem_id = re.sub(r'_\d{8}_\d{6}$', '', stem)
                        for triple in data:
                            triple["_theorem_id"] = theorem_id
                            triple["_source_file"] = str(path)
                            triple["_worker_dir"] = str(worker_dir)
                        all_triples.extend(data)
                except (json.JSONDecodeError, OSError) as e:
                    print(f"  Warning: could not read {path}: {e}")
        return all_triples

    def _load_confirmed_identifiers(self) -> Counter:
        """Load confirmed identifiers from merged or per-worker files."""
        merged = Counter()
        # Try merged file at run level
        merged_path = self.run_dir / "confirmed_identifiers.json"
        if merged_path.exists():
            try:
                data = json.loads(merged_path.read_text(encoding="utf-8"))
                merged.update(data)
                return merged
            except (json.JSONDecodeError, OSError):
                pass
        # Fall back to per-worker files
        for worker_dir in self._worker_dirs:
            ident_path = worker_dir / "confirmed_identifiers.json"
            if ident_path.exists():
                try:
                    data = json.loads(ident_path.read_text(encoding="utf-8"))
                    merged.update(data)
                except (json.JSONDecodeError, OSError):
                    pass
        return merged

    def _load_logs(self) -> dict[int | str, str]:
        """Load worker log files."""
        logs = {}
        for log_path in sorted(self.run_dir.glob("worker_*.log")):
            try:
                worker_id = log_path.stem.replace("worker_", "")
                try:
                    worker_id = int(worker_id)
                except ValueError:
                    pass
                logs[worker_id] = log_path.read_text(encoding="utf-8", errors="replace")
            except OSError:
                pass
        return logs

    def _load_results_summary(self) -> dict | None:
        """Load results_summary.json if present (single-worker runs)."""
        for loc in [self.run_dir, *self._worker_dirs]:
            path = loc / "results_summary.json"
            if path.exists():
                try:
                    return json.loads(path.read_text(encoding="utf-8"))
                except (json.JSONDecodeError, OSError):
                    pass
        return None

    # ------------------------------------------------------------------
    # Phase 1: Run Summary
    # ------------------------------------------------------------------

    def _analyze_summary(self) -> RunSummary:
        """Compute run-level and per-worker statistics."""
        summary = RunSummary()

        # Group triples by theorem
        theorems: dict[str, list[dict]] = {}
        for t in self._triples:
            tid = t.get("_theorem_id", "unknown")
            theorems.setdefault(tid, []).append(t)

        # Group by worker
        worker_theorems: dict[str, dict[str, list[dict]]] = {}
        for t in self._triples:
            wdir = t.get("_worker_dir", "single")
            tid = t.get("_theorem_id", "unknown")
            worker_theorems.setdefault(wdir, {}).setdefault(tid, []).append(t)

        # Overall stats
        for tid, triples in theorems.items():
            succeeded = any(t.get("compiled") for t in triples)
            summary.total_theorems += 1
            summary.total_attempts += len(triples)
            if succeeded:
                summary.successes += 1
            else:
                summary.failures += 1

        if summary.total_theorems > 0:
            summary.success_rate = summary.successes / summary.total_theorems
            summary.avg_attempts_per_theorem = summary.total_attempts / summary.total_theorems

        if summary.successes > 0:
            # Count attempts for successful theorems only
            success_attempts = sum(
                len(triples) for triples in theorems.values()
                if any(t.get("compiled") for t in triples)
            )
            summary.avg_attempts_per_success = success_attempts / summary.successes

        # Per-worker stats
        for wdir, w_theorems in sorted(worker_theorems.items()):
            wpath = Path(wdir)
            wid = wpath.name if wpath.name.startswith("worker_") else "single"
            ws = WorkerStats(worker_id=wid)
            for tid, triples in w_theorems.items():
                ws.total += 1
                ws.total_attempts += len(triples)
                if any(t.get("compiled") for t in triples):
                    ws.successes += 1
                else:
                    ws.failures += 1
            if ws.successes > 0:
                success_attempts = sum(
                    len(triples) for triples in w_theorems.values()
                    if any(t.get("compiled") for t in triples)
                )
                ws.avg_attempts_per_success = success_attempts / ws.successes
            summary.workers.append(ws)

        # Try to parse elapsed time from logs or results_summary
        results = self._load_results_summary()
        if results and "elapsed_seconds" in results:
            summary.elapsed_seconds = results["elapsed_seconds"]
        else:
            # Parse from log files: look for "Wall time:" in logs
            for _wid, text in self._log_texts.items():
                match = re.search(r"Wall time:\s+([\d.]+)\s*min", text)
                if match:
                    summary.elapsed_seconds += float(match.group(1)) * 60

        return summary

    # ------------------------------------------------------------------
    # Phase 2: Error Classification
    # ------------------------------------------------------------------

    def _analyze_errors(self) -> ErrorBreakdown:
        """Classify and rank all compiler errors from failed triples."""
        breakdown = ErrorBreakdown()
        category_counter: Counter = Counter()
        error_buckets: dict[str, ErrorBucket] = {}

        failed_triples = [
            t for t in self._triples if not t.get("compiled")
        ]
        failed_theorems = set()

        for triple in failed_triples:
            compiler_output = triple.get("compiler_output", "")
            theorem_id = triple.get("_theorem_id", "unknown")
            lean_code = triple.get("lean_code", "")

            if not compiler_output.strip():
                continue

            failed_theorems.add(theorem_id)

            # Parse structured errors
            errors = parse_compiler_output(compiler_output)
            if not errors:
                # Fall back to raw classification
                cat = classify_error(compiler_output)
                category_counter[cat.value] += 1
                breakdown.total_error_instances += 1

                key = _normalize_error_message(compiler_output)
                if key not in error_buckets:
                    error_buckets[key] = ErrorBucket(
                        category=cat.value,
                        normalized_message=key,
                        count=0,
                        example_full_message=compiler_output[:300],
                        example_code_snippet=lean_code[:200] if lean_code else "",
                    )
                error_buckets[key].count += 1
                if theorem_id not in error_buckets[key].affected_theorems:
                    error_buckets[key].affected_theorems.append(theorem_id)
                continue

            for err in errors:
                category_counter[err.category.value] += 1
                breakdown.total_error_instances += 1

                key = _normalize_error_message(err.message)
                if key not in error_buckets:
                    error_buckets[key] = ErrorBucket(
                        category=err.category.value,
                        normalized_message=key,
                        count=0,
                        example_full_message=err.message[:300],
                        example_code_snippet=lean_code[:200] if lean_code else "",
                    )
                error_buckets[key].count += 1
                if theorem_id not in error_buckets[key].affected_theorems:
                    error_buckets[key].affected_theorems.append(theorem_id)

        breakdown.category_counts = dict(category_counter.most_common())
        breakdown.top_errors = sorted(
            error_buckets.values(), key=lambda b: -b.count
        )[:20]

        if failed_theorems:
            breakdown.errors_per_failed_theorem = (
                breakdown.total_error_instances / len(failed_theorems)
            )

        return breakdown

    # ------------------------------------------------------------------
    # Phase 3: Identifier Analysis
    # ------------------------------------------------------------------

    def _analyze_identifiers(self) -> IdentifierAnalysis:
        """Extract and analyze hallucinated vs. confirmed identifiers."""
        analysis = IdentifierAnalysis()
        hallucinated_counter: Counter = Counter()

        # Extract hallucinated identifiers from error messages
        failed_triples = [
            t for t in self._triples if not t.get("compiled")
        ]
        for triple in failed_triples:
            compiler_output = triple.get("compiler_output", "")
            if not compiler_output:
                continue

            # Match "unknown identifier 'X'" and "unknown constant 'X'"
            for match in re.finditer(
                r"unknown (?:identifier|constant) '([^']+)'", compiler_output
            ):
                ident = match.group(1)
                hallucinated_counter[ident] += 1

            # Also match: "X not found in current namespace"
            for match in re.finditer(
                r"'([A-Z][a-zA-Z0-9_.]+)' not found", compiler_output
            ):
                ident = match.group(1)
                hallucinated_counter[ident] += 1

        analysis.total_hallucinated = sum(hallucinated_counter.values())
        analysis.unique_hallucinated = len(hallucinated_counter)
        analysis.top_hallucinated = hallucinated_counter.most_common(25)

        # Confirmed identifiers from successful proofs
        confirmed = Counter()
        success_triples = [
            t for t in self._triples if t.get("compiled")
        ]
        for triple in success_triples:
            lean_code = triple.get("lean_code", "")
            if lean_code:
                idents = _extract_identifiers(lean_code)
                confirmed.update(idents)

        # Also merge from confirmed_identifiers.json
        confirmed.update(self._confirmed_idents)

        analysis.total_confirmed = sum(confirmed.values())
        analysis.unique_confirmed = len(confirmed)
        analysis.top_confirmed = confirmed.most_common(25)

        # Near-miss analysis: find confirmed identifiers close to hallucinated ones
        confirmed_set = set(confirmed.keys())
        for hallucinated, count in hallucinated_counter.most_common(50):
            best_match = _find_nearest_identifier(hallucinated, confirmed_set)
            if best_match:
                analysis.near_misses.append((hallucinated, best_match, count))

        # Limit near misses to top 20
        analysis.near_misses = analysis.near_misses[:20]

        return analysis

    # ------------------------------------------------------------------
    # Phase 4: Failure Deep-Dive (LLM-powered, optional)
    # ------------------------------------------------------------------

    def _analyze_failures_deterministic(self) -> list[FailureAnalysis]:
        """Deterministic per-theorem failure analysis (no LLM)."""
        # Group failed triples by theorem
        theorem_triples: dict[str, list[dict]] = {}
        for t in self._triples:
            tid = t.get("_theorem_id", "unknown")
            theorem_triples.setdefault(tid, []).append(t)

        analyses = []
        for tid, triples in sorted(theorem_triples.items()):
            succeeded = any(t.get("compiled") for t in triples)
            if succeeded:
                continue

            fa = FailureAnalysis(
                theorem_id=tid,
                num_attempts=len(triples),
            )

            # Collect error categories
            cats: Counter = Counter()
            last_error = ""
            for t in triples:
                output = t.get("compiler_output", "")
                if output:
                    last_error = output
                    errors = parse_compiler_output(output)
                    for e in errors:
                        cats[e.category.value] += 1

            fa.error_categories = [c for c, _ in cats.most_common()]
            fa.last_error_snippet = last_error[:300]

            # Derive root cause from dominant error category
            if cats:
                dominant = cats.most_common(1)[0][0]
                fa.root_cause = _root_cause_from_category(dominant, last_error)
            else:
                fa.root_cause = "No compiler output available"

            analyses.append(fa)

        return analyses

    def _analyze_failures_llm(
        self, failures: list[FailureAnalysis]
    ) -> list[FailureAnalysis]:
        """Enhance failure analysis with LLM-powered root cause analysis."""
        from ..llm import complete, MODEL_HEAVY

        if not failures:
            return failures

        # Batch failures into a single LLM call for efficiency
        prompt_parts = [
            "You are analyzing Lean 4 theorem formalization failures. "
            "For each failed theorem below, provide a one-sentence root cause "
            "and suggest a specific fix.\n\n"
            "Respond as a JSON array of objects with keys: "
            "\"theorem_id\", \"root_cause\", \"suggested_fix\".\n\n"
        ]

        for fa in failures[:30]:  # Cap at 30 to stay within context
            prompt_parts.append(
                f"### {fa.theorem_id}\n"
                f"Attempts: {fa.num_attempts}\n"
                f"Error categories: {', '.join(fa.error_categories)}\n"
                f"Last error:\n```\n{fa.last_error_snippet}\n```\n\n"
            )

        prompt = "\n".join(prompt_parts)

        try:
            print("  [Supervisor] Phase 4: LLM failure analysis...")
            response = complete(
                MODEL_HEAVY, prompt,
                system="You are an expert in Lean 4 and Mathlib. Analyze compilation failures concisely.",
                max_tokens=4096,
                temperature=0.0,
            )

            # Parse JSON from response
            stripped = response.strip()
            if stripped.startswith("```"):
                lines = stripped.split("\n")
                lines = [l for l in lines if not l.strip().startswith("```")]
                stripped = "\n".join(lines)

            llm_results = json.loads(stripped)

            # Merge LLM insights back into failure analyses
            llm_by_id = {r["theorem_id"]: r for r in llm_results}
            for fa in failures:
                if fa.theorem_id in llm_by_id:
                    llm = llm_by_id[fa.theorem_id]
                    fa.root_cause = llm.get("root_cause", fa.root_cause)

        except Exception as e:
            print(f"  [Supervisor] LLM analysis failed: {e}")
            print("  Falling back to deterministic analysis.")

        return failures

    # ------------------------------------------------------------------
    # Phase 5: Recommendations
    # ------------------------------------------------------------------

    def _generate_recommendations(
        self,
        summary: RunSummary,
        errors: ErrorBreakdown,
        identifiers: IdentifierAnalysis,
        failures: list[FailureAnalysis],
    ) -> list[Recommendation]:
        """Generate ranked improvement recommendations from analysis data."""
        recs = []
        total_failures = summary.failures if summary.failures > 0 else 1

        # 1. Hallucinated identifiers
        if identifiers.total_hallucinated > 0:
            # Estimate how many failures are caused by hallucinated identifiers
            missing_count = errors.category_counts.get("missing_lemma", 0)
            syntax_count = errors.category_counts.get("syntax", 0)
            # "unknown identifier" errors are classified as SYNTAX by errors.py
            ident_affected = len(set(
                tid for bucket in errors.top_errors
                if "unknown" in bucket.normalized_message.lower()
                for tid in bucket.affected_theorems
            ))
            impact = min(ident_affected / total_failures * 100, 60)

            recs.append(Recommendation(
                rank=0,
                title="Mathlib identifier hint injection",
                description=(
                    f"{identifiers.unique_hallucinated} unique identifiers were hallucinated "
                    f"({identifiers.total_hallucinated} total occurrences). "
                    f"Inject confirmed Mathlib identifiers into the translator prompt "
                    f"or use Loogle/exact? to auto-correct. "
                    f"Top hallucinated: {', '.join(h for h, _ in identifiers.top_hallucinated[:5])}."
                ),
                estimated_impact_pct=round(impact, 1),
                effort="medium",
                affected_count=ident_affected,
            ))

        # 2. Tactic errors
        tactic_count = errors.category_counts.get("tactic", 0)
        if tactic_count > 0:
            tactic_theorems = set()
            for bucket in errors.top_errors:
                if bucket.category == "tactic":
                    tactic_theorems.update(bucket.affected_theorems)
            impact = min(len(tactic_theorems) / total_failures * 100, 50)

            recs.append(Recommendation(
                rank=0,
                title="Tactic selection improvement",
                description=(
                    f"{tactic_count} tactic errors across {len(tactic_theorems)} theorems. "
                    f"Add tactic fallback chains (e.g., try simp, then ring, then omega). "
                    f"Consider adding repair_db rules for common tactic failures."
                ),
                estimated_impact_pct=round(impact, 1),
                effort="medium",
                affected_count=len(tactic_theorems),
            ))

        # 3. Type mismatch errors
        type_count = errors.category_counts.get("type_mismatch", 0)
        if type_count > 0:
            type_theorems = set()
            for bucket in errors.top_errors:
                if bucket.category == "type_mismatch":
                    type_theorems.update(bucket.affected_theorems)
            impact = min(len(type_theorems) / total_failures * 100, 40)

            recs.append(Recommendation(
                rank=0,
                title="Type coercion handling",
                description=(
                    f"{type_count} type mismatch errors across {len(type_theorems)} theorems. "
                    f"Common cause: mixing Nat/Int/Real without explicit casts. "
                    f"Add prompt guidance for type coercion patterns and Nat division."
                ),
                estimated_impact_pct=round(impact, 1),
                effort="medium",
                affected_count=len(type_theorems),
            ))

        # 4. Near-miss identifiers -> suggest adding to repair_db
        if identifiers.near_misses:
            recs.append(Recommendation(
                rank=0,
                title="Add near-miss identifier corrections to repair_db",
                description=(
                    f"{len(identifiers.near_misses)} hallucinated identifiers have close matches "
                    f"in confirmed identifiers. Add auto-replacement rules: "
                    + "; ".join(
                        f"{h} -> {c}" for h, c, _ in identifiers.near_misses[:5]
                    ) + "."
                ),
                estimated_impact_pct=round(
                    min(len(identifiers.near_misses) / total_failures * 100, 20), 1
                ),
                effort="low",
                affected_count=sum(c for _, _, c in identifiers.near_misses),
            ))

        # 5. Empty/vacuous output
        empty_count = sum(
            1 for t in self._triples
            if not t.get("compiled")
            and not t.get("lean_code", "").strip()
        )
        if empty_count > 0:
            recs.append(Recommendation(
                rank=0,
                title="Fix empty output from models",
                description=(
                    f"{empty_count} attempts produced empty or vacuous Lean code. "
                    f"Check DeepSeek <think> block stripping and ensure code extraction "
                    f"regex handles all response formats."
                ),
                estimated_impact_pct=round(
                    min(empty_count / max(len(self._triples), 1) * 100, 30), 1
                ),
                effort="low",
                affected_count=empty_count,
            ))

        # 6. High-attempt theorems (> 10 attempts) suggest decomposition
        high_attempt = [
            fa for fa in failures if fa.num_attempts >= 10
        ]
        if high_attempt:
            recs.append(Recommendation(
                rank=0,
                title="Enable Tier 4 decomposition for hard theorems",
                description=(
                    f"{len(high_attempt)} theorems exhausted 10+ attempts without success. "
                    f"Tier 4 decomposes these into smaller sub-lemmas. "
                    f"Theorems: {', '.join(fa.theorem_id for fa in high_attempt[:5])}."
                ),
                estimated_impact_pct=round(
                    min(len(high_attempt) / total_failures * 100, 25), 1
                ),
                effort="low",
                affected_count=len(high_attempt),
            ))

        # Sort by estimated impact (highest first) and assign ranks
        recs.sort(key=lambda r: -r.estimated_impact_pct)
        for i, rec in enumerate(recs):
            rec.rank = i + 1

        return recs[:10]  # Top 10

    # ------------------------------------------------------------------
    # Main analysis entry point
    # ------------------------------------------------------------------

    def analyze(self, use_llm: bool = False) -> RunReport:
        """Run all analysis phases and produce a report.

        Args:
            use_llm: if True, Phase 4 uses an LLM for deeper failure analysis.
                Default is False (deterministic only).

        Returns:
            RunReport with all phases populated.
        """
        print(f"[Supervisor] Analyzing run: {self.run_dir}")

        # Load data
        self._worker_dirs = self._discover_workers()
        print(f"  Found {len(self._worker_dirs)} worker(s)")

        self._triples = self._load_triples()
        print(f"  Loaded {len(self._triples)} triples")

        self._confirmed_idents = self._load_confirmed_identifiers()
        print(f"  Loaded {len(self._confirmed_idents)} confirmed identifiers")

        self._log_texts = self._load_logs()
        print(f"  Loaded {len(self._log_texts)} log files")

        # Phase 1: Run Summary
        print("\n  Phase 1: Run Summary...")
        summary = self._analyze_summary()
        print(f"    {summary.successes}/{summary.total_theorems} succeeded "
              f"({summary.success_rate:.0%})")

        # Phase 2: Error Classification
        print("  Phase 2: Error Classification...")
        errors = self._analyze_errors()
        print(f"    {errors.total_error_instances} error instances across "
              f"{len(errors.category_counts)} categories")

        # Phase 3: Identifier Analysis
        print("  Phase 3: Identifier Analysis...")
        identifiers = self._analyze_identifiers()
        print(f"    {identifiers.unique_hallucinated} unique hallucinated, "
              f"{identifiers.unique_confirmed} confirmed")

        # Phase 4: Failure Deep-Dive
        print("  Phase 4: Failure Analysis...")
        failures = self._analyze_failures_deterministic()
        if use_llm and failures:
            failures = self._analyze_failures_llm(failures)
        print(f"    {len(failures)} failed theorems analyzed")

        # Phase 5: Recommendations
        print("  Phase 5: Recommendations...")
        recommendations = self._generate_recommendations(
            summary, errors, identifiers, failures
        )
        print(f"    {len(recommendations)} recommendations generated")

        report = RunReport(
            run_dir=str(self.run_dir),
            timestamp=datetime.now().isoformat(),
            summary=summary,
            error_breakdown=errors,
            identifier_analysis=identifiers,
            failure_analysis=failures,
            recommendations=recommendations,
        )

        return report

    # ------------------------------------------------------------------
    # Output formatting
    # ------------------------------------------------------------------

    def print_report(self, report: RunReport) -> None:
        """Print a human-readable report to stdout."""
        print(f"\n{'=' * 70}")
        print(f"  SUPERVISOR REPORT: {report.run_dir}")
        print(f"  Generated: {report.timestamp}")
        print(f"{'=' * 70}")

        # Phase 1
        s = report.summary
        print(f"\n--- Phase 1: Run Summary ---")
        print(f"  Theorems attempted:       {s.total_theorems}")
        print(f"  Successes:                {s.successes} ({s.success_rate:.1%})")
        print(f"  Failures:                 {s.failures}")
        print(f"  Total LLM attempts:       {s.total_attempts}")
        print(f"  Avg attempts/theorem:     {s.avg_attempts_per_theorem:.1f}")
        print(f"  Avg attempts/success:     {s.avg_attempts_per_success:.1f}")
        if s.elapsed_seconds > 0:
            print(f"  Wall time:                {s.elapsed_seconds/60:.1f} min")

        if len(s.workers) > 1:
            print(f"\n  Per-worker breakdown:")
            for w in s.workers:
                rate = w.successes / w.total * 100 if w.total > 0 else 0
                print(f"    {w.worker_id}: {w.successes}/{w.total} "
                      f"({rate:.0f}%), {w.total_attempts} attempts")

        # Phase 2
        e = report.error_breakdown
        print(f"\n--- Phase 2: Error Classification ---")
        print(f"  Total error instances: {e.total_error_instances}")
        print(f"  Errors per failed theorem: {e.errors_per_failed_theorem:.1f}")
        print(f"\n  Error categories:")
        for cat, count in sorted(e.category_counts.items(), key=lambda x: -x[1]):
            pct = count / e.total_error_instances * 100 if e.total_error_instances else 0
            print(f"    {cat:20s} {count:5d}  ({pct:4.1f}%)")

        if e.top_errors:
            print(f"\n  Top 10 specific errors:")
            for i, bucket in enumerate(e.top_errors[:10], 1):
                print(f"    {i:2d}. [{bucket.category}] {bucket.normalized_message}")
                print(f"        Count: {bucket.count}, "
                      f"Theorems: {len(bucket.affected_theorems)}")

        # Phase 3
        ident = report.identifier_analysis
        print(f"\n--- Phase 3: Identifier Analysis ---")
        print(f"  Hallucinated: {ident.unique_hallucinated} unique "
              f"({ident.total_hallucinated} total)")
        print(f"  Confirmed:    {ident.unique_confirmed} unique "
              f"({ident.total_confirmed} total)")

        if ident.top_hallucinated:
            print(f"\n  Top hallucinated identifiers:")
            for name, count in ident.top_hallucinated[:10]:
                print(f"    {count:3d}x  {name}")

        if ident.top_confirmed:
            print(f"\n  Top confirmed identifiers (from successes):")
            for name, count in ident.top_confirmed[:10]:
                print(f"    {count:3d}x  {name}")

        if ident.near_misses:
            print(f"\n  Near-miss corrections (hallucinated -> confirmed):")
            for hallucinated, confirmed, count in ident.near_misses[:10]:
                print(f"    {hallucinated}  ->  {confirmed}  ({count}x)")

        # Phase 4
        if report.failure_analysis:
            print(f"\n--- Phase 4: Failed Theorems ({len(report.failure_analysis)}) ---")
            for fa in report.failure_analysis[:20]:
                cats = ", ".join(fa.error_categories[:3]) if fa.error_categories else "none"
                print(f"  [{fa.num_attempts:2d} attempts] {fa.theorem_id}")
                print(f"    Categories: {cats}")
                print(f"    Root cause: {fa.root_cause}")

        # Phase 5
        if report.recommendations:
            print(f"\n--- Phase 5: Top Recommendations ---")
            for rec in report.recommendations:
                print(f"\n  #{rec.rank}: {rec.title}")
                print(f"    Impact: ~{rec.estimated_impact_pct}% of failures "
                      f"({rec.affected_count} affected)")
                print(f"    Effort: {rec.effort}")
                print(f"    {rec.description}")

        print(f"\n{'=' * 70}")

    def save_report(self, report: RunReport, path: Path | None = None) -> None:
        """Save report as both JSON and Markdown."""
        if path is None:
            path = self.run_dir / "supervisor_report.json"

        path.parent.mkdir(parents=True, exist_ok=True)

        # JSON
        json_path = path.with_suffix(".json")
        json_path.write_text(
            json.dumps(report.to_dict(), indent=2, default=str),
            encoding="utf-8",
        )
        print(f"\n  Report saved: {json_path}")

        # Markdown
        md_path = path.with_suffix(".md")
        md_path.write_text(
            self._render_markdown(report),
            encoding="utf-8",
        )
        print(f"  Report saved: {md_path}")

    def _render_markdown(self, report: RunReport) -> str:
        """Render the report as Markdown."""
        lines = []
        lines.append(f"# Supervisor Report")
        lines.append(f"")
        lines.append(f"**Run**: `{report.run_dir}`")
        lines.append(f"**Generated**: {report.timestamp}")
        lines.append("")

        # Phase 1
        s = report.summary
        lines.append("## Phase 1: Run Summary")
        lines.append("")
        lines.append(f"| Metric | Value |")
        lines.append(f"|--------|-------|")
        lines.append(f"| Theorems attempted | {s.total_theorems} |")
        lines.append(f"| Successes | {s.successes} ({s.success_rate:.1%}) |")
        lines.append(f"| Failures | {s.failures} |")
        lines.append(f"| Total LLM attempts | {s.total_attempts} |")
        lines.append(f"| Avg attempts/theorem | {s.avg_attempts_per_theorem:.1f} |")
        lines.append(f"| Avg attempts/success | {s.avg_attempts_per_success:.1f} |")
        if s.elapsed_seconds > 0:
            lines.append(f"| Wall time | {s.elapsed_seconds/60:.1f} min |")
        lines.append("")

        if len(s.workers) > 1:
            lines.append("### Per-worker breakdown")
            lines.append("")
            lines.append("| Worker | Success | Total | Rate | Attempts |")
            lines.append("|--------|---------|-------|------|----------|")
            for w in s.workers:
                rate = w.successes / w.total * 100 if w.total > 0 else 0
                lines.append(
                    f"| {w.worker_id} | {w.successes} | {w.total} | "
                    f"{rate:.0f}% | {w.total_attempts} |"
                )
            lines.append("")

        # Phase 2
        e = report.error_breakdown
        lines.append("## Phase 2: Error Classification")
        lines.append("")
        lines.append(f"Total error instances: {e.total_error_instances}")
        lines.append("")
        lines.append("| Category | Count | % |")
        lines.append("|----------|-------|---|")
        for cat, count in sorted(e.category_counts.items(), key=lambda x: -x[1]):
            pct = count / e.total_error_instances * 100 if e.total_error_instances else 0
            lines.append(f"| {cat} | {count} | {pct:.1f}% |")
        lines.append("")

        if e.top_errors:
            lines.append("### Top 10 specific errors")
            lines.append("")
            for i, bucket in enumerate(e.top_errors[:10], 1):
                lines.append(
                    f"{i}. **[{bucket.category}]** `{bucket.normalized_message}` "
                    f"({bucket.count}x, {len(bucket.affected_theorems)} theorems)"
                )
            lines.append("")

        # Phase 3
        ident = report.identifier_analysis
        lines.append("## Phase 3: Identifier Analysis")
        lines.append("")
        lines.append(
            f"- Hallucinated: {ident.unique_hallucinated} unique "
            f"({ident.total_hallucinated} total)"
        )
        lines.append(
            f"- Confirmed: {ident.unique_confirmed} unique "
            f"({ident.total_confirmed} total)"
        )
        lines.append("")

        if ident.top_hallucinated:
            lines.append("### Top hallucinated identifiers")
            lines.append("")
            for name, count in ident.top_hallucinated[:10]:
                lines.append(f"- `{name}` ({count}x)")
            lines.append("")

        if ident.near_misses:
            lines.append("### Near-miss corrections")
            lines.append("")
            lines.append("| Hallucinated | Confirmed match | Count |")
            lines.append("|-------------|-----------------|-------|")
            for h, c, count in ident.near_misses[:10]:
                lines.append(f"| `{h}` | `{c}` | {count} |")
            lines.append("")

        # Phase 4
        if report.failure_analysis:
            lines.append(f"## Phase 4: Failed Theorems ({len(report.failure_analysis)})")
            lines.append("")
            for fa in report.failure_analysis[:20]:
                cats = ", ".join(fa.error_categories[:3]) if fa.error_categories else "none"
                lines.append(f"- **{fa.theorem_id}** ({fa.num_attempts} attempts)")
                lines.append(f"  - Categories: {cats}")
                lines.append(f"  - Root cause: {fa.root_cause}")
            lines.append("")

        # Phase 5
        if report.recommendations:
            lines.append("## Phase 5: Recommendations")
            lines.append("")
            for rec in report.recommendations:
                lines.append(f"### #{rec.rank}: {rec.title}")
                lines.append("")
                lines.append(
                    f"- **Impact**: ~{rec.estimated_impact_pct}% of failures "
                    f"({rec.affected_count} affected)"
                )
                lines.append(f"- **Effort**: {rec.effort}")
                lines.append(f"- {rec.description}")
                lines.append("")

        return "\n".join(lines)


# ---------------------------------------------------------------------------
# Helper functions
# ---------------------------------------------------------------------------

def _normalize_error_message(message: str) -> str:
    """Normalize an error message for grouping.

    Strips line/column numbers, file paths, and specific identifiers
    to group similar errors together.
    """
    msg = message.strip()
    # Take first line only
    msg = msg.split("\n")[0]
    # Strip file path prefix
    msg = re.sub(r"^.*\.lean:\d+:\d+:\s*error:\s*", "", msg)
    # Normalize specific identifier names to a placeholder
    msg = re.sub(r"'[^']+'", "'<IDENT>'", msg)
    # Strip trailing whitespace and limit length
    msg = msg.strip()[:120]
    return msg


def _find_nearest_identifier(
    hallucinated: str, confirmed: set[str]
) -> str | None:
    """Find the confirmed identifier most similar to a hallucinated one.

    Uses a simple heuristic: shared namespace prefix + edit distance on
    the last component. Returns None if no plausible match exists.
    """
    if not confirmed:
        return None

    h_parts = hallucinated.split(".")
    if len(h_parts) < 2:
        return None

    h_namespace = ".".join(h_parts[:-1])
    h_leaf = h_parts[-1].lower()

    best_match = None
    best_score = 0

    for candidate in confirmed:
        c_parts = candidate.split(".")
        if len(c_parts) < 2:
            continue

        c_namespace = ".".join(c_parts[:-1])
        c_leaf = c_parts[-1].lower()

        # Score: namespace match is worth a lot, leaf similarity adds to it
        score = 0
        if c_namespace == h_namespace:
            score += 50  # same namespace
        elif c_namespace.startswith(h_namespace) or h_namespace.startswith(c_namespace):
            score += 25  # partial namespace overlap

        if score == 0:
            continue  # don't match across unrelated namespaces

        # Leaf similarity: longest common prefix ratio
        common = 0
        for a, b in zip(h_leaf, c_leaf):
            if a == b:
                common += 1
            else:
                break
        if max(len(h_leaf), len(c_leaf)) > 0:
            prefix_ratio = common / max(len(h_leaf), len(c_leaf))
            score += prefix_ratio * 40

        # Bonus if leaf is substring
        if h_leaf in c_leaf or c_leaf in h_leaf:
            score += 20

        if score > best_score and score >= 40:  # threshold
            best_score = score
            best_match = candidate

    return best_match


def _root_cause_from_category(category: str, last_error: str) -> str:
    """Derive a root cause summary from the dominant error category."""
    if category == "syntax":
        if "unknown identifier" in last_error.lower():
            return "Hallucinated identifier (does not exist in Mathlib)"
        if "unexpected token" in last_error.lower():
            return "Lean 3 syntax used instead of Lean 4"
        return "Syntax error in generated Lean code"

    if category == "tactic":
        if "unsolved goals" in last_error.lower():
            return "Tactic proof incomplete (unsolved goals remain)"
        if "no goals" in last_error.lower():
            return "Tactic applied to already-solved goal"
        return "Tactic failure (wrong tactic or wrong arguments)"

    if category == "type_mismatch":
        if "nat" in last_error.lower() and ("int" in last_error.lower() or "real" in last_error.lower()):
            return "Type coercion error (Nat vs Int/Real)"
        return "Type mismatch in proof term"

    if category == "missing_lemma":
        return "Referenced a Mathlib lemma that does not exist"

    return f"Unclassified error ({category})"
