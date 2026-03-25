"""Pipeline orchestrator — chains agents 1-6 and manages the work queue.

Two main paths:
  Ingest:     PDF/text → claims → triage → librarian → backlog
  Formalize:  backlog → translator → Lean 4 output

Training data (translation triples) is collected from every attempt.
"""

import json
from dataclasses import dataclass, field
from datetime import datetime
from pathlib import Path

from .agents.extraction import ExtractionAgent
from .agents.claim_extraction import ClaimExtractionAgent
from .agents.triage import TriageAgent, TriageBatch, InboxItem, ItemCategory
from .agents.librarian import (
    LibrarianAgent, Library, InMemoryLibrary, RosettaStoneLibrary, StackedLibrary,
    MatchType,
)
from .inbox import Inbox as InboxStore, InboxEntry, InboxStatus, InboxOrigin
from .knowledge_graph import (
    StrategyKB, extract_proof_profile, build_from_rosetta,
)
from .agents.translator import (
    TranslatorAgent, TranslationResult, TranslationOutcome, MAX_DIRECT_ATTEMPTS,
    SubLemma, DEFINITION_MAX_ATTEMPTS,
)
from .agents.failure_analyst import (
    FailureAnalyst, AnalysisReport, build_retry_context,
    RETRY_DIRECT_ATTEMPTS, RETRY_TIER1_ATTEMPTS, RETRY_TIER2_ATTEMPTS,
)
from .backlog import Backlog, BacklogEntry, BacklogStatus, DependencyType
from .lean.compiler import RealLeanCompiler
from .mathlib_index import MathlibIndex
from .prompt_tuner import PromptTuner
from .schemas import ExtractionResult, ExtractedItem, StatementType, ClaimRole

PROJECT_ROOT = Path(__file__).resolve().parents[2]


@dataclass
class PipelineResult:
    """Result of formalizing one backlog item."""
    item_id: str
    success: bool
    translation: TranslationResult | None = None
    lean_file: str | None = None
    error: str | None = None


class Pipeline:
    """Orchestrates agents 1-6 into a runnable pipeline.

    Args:
        lean_project_dir: path to a Lake project (for Mathlib access).
            If None, compiler runs in standalone mode.
        output_dir: where to save Lean files and training triples.
        library: search backend for the Librarian. Defaults to InMemoryLibrary.
    """

    def __init__(
        self,
        lean_project_dir: Path | None = None,
        output_dir: Path | None = None,
        library: Library | None = None,
        worker_id: int | str | None = None,
        mathlib_index: MathlibIndex | None = None,
    ):
        self.output_dir = output_dir or (PROJECT_ROOT / "outputs")

        # Prompt Tuner — learns from failures across the run
        self.tuner = PromptTuner()

        # Mathlib RAG index — retrieves real declaration names for prompts
        self.mathlib_index = mathlib_index

        # Strategy Knowledge Base — learns from verified proofs (Agent 7)
        self.strategy_kb = StrategyKB()

        # Agents
        self.extraction = ExtractionAgent()
        self.claim_extraction = ClaimExtractionAgent()
        self.triage = TriageAgent()
        self.librarian = LibrarianAgent(library or InMemoryLibrary())
        self.compiler = RealLeanCompiler(project_dir=lean_project_dir, worker_id=worker_id)
        self.translator = TranslatorAgent(
            compiler=self.compiler, tuner=self.tuner,
            mathlib_index=self.mathlib_index,
            strategy_kb=self.strategy_kb,
        )

        # State
        self.inbox = InboxStore()
        self.backlog = Backlog()

    # ------------------------------------------------------------------
    # Ingest path
    # ------------------------------------------------------------------

    def extract(
        self,
        pdf_path: Path,
        start_page: int,
        end_page: int,
        source_label: str = "",
    ) -> ExtractionResult:
        """PDF → Agent 1 (extraction) → Agent 3 (triage) → Agent 4 (librarian) → backlog."""
        print(f"=== Extract: {pdf_path.name} pp.{start_page}-{end_page} ===\n")

        result = self.extraction.extract_from_pdf(
            pdf_path, start_page, end_page, source_label
        )
        print(f"  Extracted {len(result.items)} items")

        self._ingest(result)
        return result

    def extract_text(
        self,
        text: str,
        source_label: str = "",
    ) -> ExtractionResult:
        """Text → Agent 2 (ensemble) → Agent 3 (triage) → Agent 4 (librarian) → backlog."""
        print(f"=== Extract from text: {source_label or '(inline)'} ===\n")

        result = self.claim_extraction.extract(text, source_label)
        print(f"  Extracted {len(result.items)} items")

        self._ingest(result)
        return result

    def _ingest(self, result: ExtractionResult) -> None:
        """Triage → Inbox → promote() → Queue. Remarks are skipped."""
        batch = self.triage.triage(result)
        skipped = 0
        for triage_item in batch.items:
            if triage_item.category == ItemCategory.REMARK:
                skipped += 1
                continue
            self.inbox.add(
                item=triage_item.item,
                category=triage_item.category,
                origin=InboxOrigin.EXTRACTION,
            )
        promoted = self.promote()
        stats = self.backlog.stats
        skip_msg = f" ({skipped} remarks skipped)" if skipped else ""
        print(f"  Promoted {promoted} items{skip_msg} | Backlog: {stats}")

    def promote(self, rescreen: bool = False) -> int:
        """Screen NEW inbox items via Librarian, move survivors to Queue.

        Args:
            rescreen: if True, also re-screen PROMOTED items (catches
                new duplicates after the Rosetta Stone has grown).

        Returns:
            Number of items promoted to the backlog.
        """
        candidates = self.inbox.new_entries()
        if rescreen:
            candidates += self.inbox.promoted()
        if not candidates:
            return 0

        # Build a TriageBatch for the Librarian
        batch = TriageBatch(source="promote")
        for ie in candidates:
            batch.items.append(InboxItem(item=ie.item, category=ie.category))

        lib_result = self.librarian.check(batch)

        # Build lookup sets for O(1) matching
        exact_ids = {v.item.item.id for v in lib_result.exact_matches}
        backlog_verdicts = {v.item.item.id: v for v in lib_result.to_backlog}

        promoted_count = 0
        for ie in candidates:
            if ie.item.id in exact_ids:
                ie.status = InboxStatus.DUPLICATE
                # Find the verdict for screening metadata
                for v in lib_result.exact_matches:
                    if v.item.item.id == ie.item.id:
                        ie.screening_verdict = "exact"
                        ie.matched_name = v.matched_name
                        ie.similarity = v.similarity
                        break
            elif ie.item.id in backlog_verdicts:
                ie.status = InboxStatus.PROMOTED
                ie.promoted_at = datetime.now()
                v = backlog_verdicts[ie.item.id]
                ie.screening_verdict = v.match_type.value
                ie.matched_name = v.matched_name
                ie.similarity = v.similarity

                # Route to backlog based on origin
                if ie.origin == InboxOrigin.AXIOM_STUB:
                    self.backlog.add_axiomatized(
                        item=ie.item,
                        category=ie.category,
                        dependency_type=DependencyType.CITATION,
                        created_during=ie.created_during,
                    )
                else:
                    entry = BacklogEntry(item=ie.item, category=ie.category)
                    # Warm-start: attach reference lean code for partial matches
                    if (v.match_type == MatchType.PARTIAL
                            and v.matched_name
                            and self.mathlib_index):
                        ref_lean = self.mathlib_index.get_rosetta_lean(
                            v.matched_name
                        )
                        if ref_lean:
                            entry.reference_lean = ref_lean
                            entry.reference_name = v.matched_name
                            entry.reference_similarity = v.similarity
                    self.backlog.add(entry)
                promoted_count += 1

        return promoted_count

    # ------------------------------------------------------------------
    # Formalization path
    # ------------------------------------------------------------------

    def formalize_next(self) -> PipelineResult | None:
        """Pick next ready item → Agent 6 → update backlog.

        Prioritizes theorems over definitions (theorems first, then definitions).
        """
        ready = self.backlog.ready()
        if not ready:
            print("No ready items in backlog.")
            return None

        # Theorems first, then definitions
        ready.sort(key=lambda e: (0 if e.category == ItemCategory.THEOREM else 1))

        return self.formalize_entry(ready[0])

    def formalize_all(self) -> list[PipelineResult]:
        """Formalize all pending items (theorems and definitions) sequentially."""
        results = []
        while True:
            result = self.formalize_next()
            if result is None:
                break
            results.append(result)

        successes = sum(1 for r in results if r.success)
        print(f"\n{'=' * 60}")
        print(f"Batch complete: {successes}/{len(results)} formalized")
        print(f"{'=' * 60}")

        return results

    def analyze_and_retry(
        self,
        max_cycles: int = 2,
        use_llm: bool = False,
    ) -> list[PipelineResult]:
        """Post-batch failure analysis and retry loop.

        1. Collect FAILED entries from backlog
        2. Run FailureAnalyst.analyze()
        3. Inject lessons into PromptTuner
        4. Transition selected items: FAILED → RETRY → READY
        5. Run formalize_all() on retries
        6. Save analysis report
        7. Early stop if no new successes

        Args:
            max_cycles: maximum retry cycles (default 2)
            use_llm: use LLM for enhanced root-cause analysis

        Returns:
            All PipelineResults from retry passes.
        """
        analyst = FailureAnalyst()
        all_results: list[PipelineResult] = []

        for cycle in range(max_cycles):
            failed = self.backlog.failed()
            if not failed:
                print(f"\n  No failed items to retry.")
                break

            print(f"\n{'=' * 60}")
            print(f"Failure Analysis — Cycle {cycle + 1}/{max_cycles}")
            print(f"  Analyzing {len(failed)} failed items...")
            print(f"{'=' * 60}")

            report = analyst.analyze(
                failed_entries=failed,
                output_dir=self.output_dir,
                cycle=cycle,
                use_llm=use_llm,
            )

            print(f"  Clusters: {len(report.clusters)}")
            for c in report.clusters[:5]:
                print(f"    {c.error_category.value}: {c.count} items — {c.normalized_key[:60]}")
            print(f"  Lessons: {len(report.lessons)}")
            print(f"  Retry: {len(report.retry_items)}, Skip: {len(report.skip_items)}")

            if not report.retry_items:
                print("  No items selected for retry.")
                break

            # Inject lessons into PromptTuner
            self.tuner.add_failure_lessons(report.lessons)

            # Save analysis report
            analysis_dir = self.output_dir / "failure_analysis"
            analysis_dir.mkdir(parents=True, exist_ok=True)
            report_path = analysis_dir / f"cycle_{cycle}.json"
            report_path.write_text(
                json.dumps(report.to_dict(), indent=2),
                encoding="utf-8",
            )

            # Transition selected items to READY
            for item_id in report.retry_items:
                ctx = build_retry_context(
                    item_id, self.output_dir, report.lessons,
                )
                self.backlog.mark_retry(item_id, retry_context=ctx)

            # Run formalize_all on the re-queued items
            print(f"\n  Retrying {len(report.retry_items)} items...")
            cycle_results = self.formalize_all()
            all_results.extend(cycle_results)

            successes = sum(1 for r in cycle_results if r.success)
            print(f"  Retry cycle {cycle + 1}: {successes}/{len(cycle_results)} succeeded")

            # Early stop if no progress
            if successes == 0:
                print("  No new successes — stopping retry loop.")
                break

        return all_results

    def formalize_entry(self, entry: BacklogEntry) -> PipelineResult:
        """Formalize a specific backlog entry.

        Routes to the appropriate formalization path based on category:
        - THEOREM: two-phase translation (direct + guided escalation)
        - DEFINITION: simpler definition formalization path
        - REMARK: skip (not formalizable)
        """
        if entry.category == ItemCategory.REMARK:
            print(f"\n=== Skip (remark): {entry.item.id} ===")
            return PipelineResult(
                item_id=entry.item.id,
                success=False,
                error="remark — not formalizable",
            )
        if entry.category == ItemCategory.DEFINITION:
            return self._formalize_definition(entry)
        else:
            return self._formalize_theorem(entry)

    def _formalize_theorem(self, entry: BacklogEntry) -> PipelineResult:
        """Formalize a theorem backlog entry.

        Two-phase: direct attempt first, then guided escalation
        (Tier 1 → Tier 2 → Tier 3) if direct fails. Direct failures
        carry forward as context for the guided phase.
        """
        item = entry.item
        print(f"\n=== Formalize (theorem): {item.id} ===\n")

        self.backlog.mark_in_progress(item.id)

        try:
            # Phase 1: Direct — let the model prove without a plan
            direct_result = self.translator.translate_direct(item)

            if direct_result.outcome == TranslationOutcome.SUCCESS:
                translation = direct_result
            else:
                # Phase 2: Guided — escalate through tiers with NL proof
                # (Agent 5's structured plans over-constrain models; NL proof
                # is already passed through and models use Mathlib shortcuts)
                print(f"\n  Escalating to guided mode (Tier 1 → Tier 2 → Tier 3)...")
                translation = self.translator.translate_unstructured(
                    item, prior_triples=direct_result.triples,
                )

            # Feed triples to the tuner so future theorems benefit
            triple_dicts = [
                {
                    "compiled": t.compiled,
                    "compiler_output": t.compiler_output,
                    "lean_code": t.lean_code,
                }
                for t in translation.triples
            ]
            self.tuner.ingest_triples(triple_dicts)

            if translation.outcome == TranslationOutcome.SUCCESS:
                lean_file = self._save_lean(item.id, translation.lean_code)
                unblocked = self.backlog.mark_completed(item.id, lean_file=lean_file)
                if unblocked:
                    print(f"  Unblocked: {', '.join(unblocked)}")
                self._save_triples(item.id, translation)
                self._save_rosetta_entry(item, translation)
                self._update_strategy_kb(item, translation)
                print(f"=== SUCCESS: {item.id} "
                      f"({translation.total_attempts} attempts) ===")
                return PipelineResult(
                    item_id=item.id,
                    success=True,
                    translation=translation,
                    lean_file=lean_file,
                )
            elif translation.outcome == TranslationOutcome.DECOMPOSED:
                # Assembly verified with axiom stubs — sub-lemmas need proving
                lean_file = self._save_lean(item.id, translation.lean_code)
                self.backlog.mark_decomposed(item.id, lean_file=lean_file)
                sub_ids = self._create_sub_lemma_entries(
                    parent_id=item.id,
                    sub_lemmas=translation.sub_lemmas,
                )
                self._save_triples(item.id, translation)
                print(f"=== DECOMPOSED: {item.id} → "
                      f"{len(sub_ids)} sub-lemmas "
                      f"({translation.total_attempts} attempts) ===")
                return PipelineResult(
                    item_id=item.id,
                    success=True,
                    translation=translation,
                    lean_file=lean_file,
                )
            else:
                reason = "Translation exhausted all attempts"
                if translation.triples:
                    reason = translation.triples[-1].compiler_output[:200]
                self.backlog.mark_failed(item.id, reason=reason)
                self._save_triples(item.id, translation)
                self._save_failure_record(item.id, translation, reason)
                print(f"=== FAILED: {item.id} "
                      f"({translation.total_attempts} attempts) ===")
                return PipelineResult(
                    item_id=item.id,
                    success=False,
                    translation=translation,
                    error=reason,
                )
        except Exception as e:
            self.backlog.mark_failed(item.id, reason=str(e))
            self._save_failure_record(item.id, None, str(e))
            print(f"=== ERROR: {item.id} — {e} ===")
            return PipelineResult(item_id=item.id, success=False, error=str(e))

    def _formalize_definition(self, entry: BacklogEntry) -> PipelineResult:
        """Formalize a definition backlog entry.

        Simpler path than theorems: direct attempts with escalation,
        no decomposition or oracle tier.
        """
        item = entry.item
        print(f"\n=== Formalize (definition): {item.id} ===\n")

        self.backlog.mark_in_progress(item.id)

        try:
            translation = self.translator.translate_definition(item)

            # Feed triples to the tuner
            triple_dicts = [
                {
                    "compiled": t.compiled,
                    "compiler_output": t.compiler_output,
                    "lean_code": t.lean_code,
                }
                for t in translation.triples
            ]
            self.tuner.ingest_triples(triple_dicts)

            if translation.outcome == TranslationOutcome.DEFINITION_SUCCESS:
                lean_file = self._save_lean(item.id, translation.lean_code)
                unblocked = self.backlog.mark_completed(item.id, lean_file=lean_file)
                if unblocked:
                    print(f"  Unblocked: {', '.join(unblocked)}")
                self._save_triples(item.id, translation)
                self._save_rosetta_entry(item, translation)
                self._update_strategy_kb(item, translation)
                print(f"=== SUCCESS (definition): {item.id} "
                      f"({translation.total_attempts} attempts) ===")
                return PipelineResult(
                    item_id=item.id,
                    success=True,
                    translation=translation,
                    lean_file=lean_file,
                )
            else:
                reason = "Definition formalization exhausted all attempts"
                if translation.triples:
                    reason = translation.triples[-1].compiler_output[:200]
                self.backlog.mark_failed(item.id, reason=reason)
                self._save_triples(item.id, translation)
                self._save_failure_record(item.id, translation, reason)
                print(f"=== FAILED (definition): {item.id} "
                      f"({translation.total_attempts} attempts) ===")
                return PipelineResult(
                    item_id=item.id,
                    success=False,
                    translation=translation,
                    error=reason,
                )
        except Exception as e:
            self.backlog.mark_failed(item.id, reason=str(e))
            self._save_failure_record(item.id, None, str(e))
            print(f"=== ERROR: {item.id} — {e} ===")
            return PipelineResult(item_id=item.id, success=False, error=str(e))

    # ------------------------------------------------------------------
    # Sub-lemma creation
    # ------------------------------------------------------------------

    def _create_sub_lemma_entries(
        self,
        parent_id: str,
        sub_lemmas: list[SubLemma],
    ) -> list[str]:
        """Create backlog entries for sub-lemmas from a decomposition.

        Each sub-lemma becomes a THEOREM entry with full pipeline access
        (Direct 3 + Tier 1 7 + Tier 2 5 + its own Tier 3 if needed).
        """
        created_ids = []
        for sl in sub_lemmas:
            sub_id = f"{parent_id}/sub/{sl.name}"
            sub_item = ExtractedItem(
                id=sub_id,
                type=StatementType.LEMMA,
                role=ClaimRole.CLAIMED_RESULT,
                statement=sl.nl_description,
                proof=sl.nl_proof_hint or None,
                proof_sketch=f"Lean signature: {sl.lean_signature}",
                section=f"decomposition of {parent_id}",
                dependencies=[
                    f"{parent_id}/sub/{dep}" for dep in sl.depends_on
                ],
            )
            self.inbox.add(
                item=sub_item,
                category=ItemCategory.THEOREM,
                origin=InboxOrigin.DECOMPOSITION,
            )
            created_ids.append(sub_id)
            print(f"    Sub-lemma queued: {sub_id}")

        self.promote()
        return created_ids

    # ------------------------------------------------------------------
    # Persistence
    # ------------------------------------------------------------------

    def _save_lean(self, item_id: str, code: str) -> str:
        lean_dir = self.output_dir / "lean"
        lean_dir.mkdir(parents=True, exist_ok=True)
        safe = item_id.lower().replace(" ", "_").replace("/", "_")
        path = lean_dir / f"{safe}.lean"
        path.write_text(code, encoding="utf-8")
        print(f"  Lean saved: {path}")
        return str(path)

    @staticmethod
    def _classify_proof_status(lean_code: str) -> str:
        """Classify proof quality based on Lean code content.

        Returns:
            "verified" — no axiom declarations at all
            "deferred_axioms" — has axiom stubs for dependencies but
                target is a real theorem/lemma/def
        """
        import re
        if not lean_code:
            return "verified"
        # Check for any `axiom` declarations (outside comments)
        # Simple check: look for lines starting with `axiom `
        for line in lean_code.split("\n"):
            stripped = line.strip()
            if stripped.startswith("axiom "):
                return "deferred_axioms"
        return "verified"

    def _save_rosetta_entry(self, item, translation: TranslationResult) -> None:
        """Append a new Rosetta Stone entry for this verified proof.

        Each entry maps natural language (statement + proof) to verified
        Lean 4 code. The growing corpus feeds retrieval (Librarian) and
        future model retraining.
        """
        rosetta_path = self.output_dir / "rosetta_stone.jsonl"
        rosetta_path.parent.mkdir(parents=True, exist_ok=True)

        # Extract Mathlib identifiers used in the successful proof
        from .prompt_tuner import _extract_identifiers
        idents = sorted(_extract_identifiers(translation.lean_code or ""))

        # Classify proof quality
        proof_status = self._classify_proof_status(translation.lean_code or "")

        entry = {
            "id": item.id,
            "statement": item.statement,
            "nl_proof": item.proof or item.proof_sketch or "",
            "lean_code": translation.lean_code,
            "proof_status": proof_status,
            "mathlib_identifiers": idents,
            "attempts": translation.total_attempts,
            "model": next(
                (t.model for t in reversed(translation.triples) if t.compiled),
                "unknown",
            ),
            "timestamp": datetime.now().isoformat(),
        }

        with open(rosetta_path, "a", encoding="utf-8") as f:
            f.write(json.dumps(entry) + "\n")

        # Also append to consolidated rosetta (cross-chapter search corpus)
        consolidated = self.output_dir.parent / "rosetta_consolidated.jsonl"
        if consolidated.parent.exists():
            try:
                with open(consolidated, "a", encoding="utf-8") as f:
                    f.write(json.dumps(entry) + "\n")
            except Exception:
                pass  # Non-critical — consolidated can be rebuilt

        # Inline axiom check: extract axioms and add unresolved ones to inbox.
        # Runs even without a mathlib_index — resolution matching is optional,
        # but inbox feedback is always needed.
        self._check_axioms_inline(item.id, translation.lean_code or "")

    def _check_axioms_inline(self, item_id: str, lean_code: str) -> None:
        """After a successful compilation, extract axioms from the code and
        add unresolved ones to the inbox for future formalization.

        If a mathlib_index is available, also checks for matches against
        Mathlib/Rosetta and logs resolutions. But inbox feedback always runs.
        """
        from .agents.axiom_resolver import (
            extract_axioms, resolve_axiom, extract_axiom_items, MatchCategory,
        )

        axioms = extract_axioms(lean_code, file_path=item_id)
        if not axioms:
            return

        # Resolution matching (optional — needs mathlib_index)
        if self.mathlib_index is not None:
            resolutions_path = self.output_dir / "axiom_resolutions.jsonl"
            for ax in axioms:
                match = resolve_axiom(ax, self.mathlib_index)
                if match.category in (MatchCategory.MATHLIB_EXACT, MatchCategory.ROSETTA_EXACT):
                    entry = {
                        "item_id": item_id,
                        "axiom_name": ax.name,
                        "category": match.category.value,
                        "match_name": match.best_match_name,
                        "match_score": round(match.best_match_score, 3),
                        "match_source": match.best_match_source,
                        "timestamp": datetime.now().isoformat(),
                    }
                    try:
                        with open(resolutions_path, "a", encoding="utf-8") as f:
                            f.write(json.dumps(entry) + "\n")
                    except Exception:
                        pass  # Non-critical logging

        # Create inbox entries for unresolved axioms (always runs)
        axiom_items = extract_axiom_items(
            lean_code, file_path=item_id, mathlib_index=self.mathlib_index,
        )
        for ax_item in axiom_items:
            self.inbox.add(
                item=ax_item,
                category=ItemCategory.THEOREM,
                origin=InboxOrigin.AXIOM_STUB,
                created_during=item_id,
            )
        if axiom_items:
            self.promote()

    def _save_failure_record(
        self, item_id: str, translation: TranslationResult | None, error: str | None,
    ) -> None:
        """Write a structured failure record for post-run diagnostics."""
        failures_dir = self.output_dir / "failures"
        failures_dir.mkdir(parents=True, exist_ok=True)

        safe = item_id.lower().replace(" ", "_").replace("/", "_")

        record: dict = {
            "item_id": item_id,
            "timestamp": datetime.now().isoformat(),
            "error": error,
        }

        if translation and translation.triples:
            triples = translation.triples
            record["total_attempts"] = len(triples)

            # Classify tiers reached
            models_used = list(dict.fromkeys(t.model for t in triples))
            record["models_used"] = models_used

            last = triples[-1]
            record["last_compiler_error"] = last.compiler_output
            record["last_model"] = last.model

            # Classify failure cause
            last_err = last.compiler_output or ""
            if "empty or vacuous code" in last_err:
                cause = "empty_output"
            elif "does not exist" in last_err or "unknown module" in last_err.lower():
                cause = "missing_olean"
            elif any(kw in last_err.lower() for kw in ("unknown identifier", "not found")):
                cause = "hallucinated_identifier"
            elif "timeout" in last_err.lower() or "deterministic timeout" in last_err.lower():
                cause = "lean_timeout"
            else:
                cause = "compiler_error"
            record["cause"] = cause
        elif translation:
            record["total_attempts"] = 0
            record["cause"] = "no_triples"
        else:
            record["total_attempts"] = 0
            record["cause"] = "crash"

        path = failures_dir / f"{safe}.json"
        path.write_text(json.dumps(record, indent=2), encoding="utf-8")

    def _save_triples(self, item_id: str, translation: TranslationResult) -> None:
        triples_dir = self.output_dir / "triples"
        triples_dir.mkdir(parents=True, exist_ok=True)
        safe = item_id.lower().replace(" ", "_").replace("/", "_")
        data = []
        for t in translation.triples:
            data.append({
                "structured_proof": t.structured_proof.model_dump(mode="json"),
                "lean_code": t.lean_code,
                "compiler_output": t.compiler_output,
                "compiled": t.compiled,
                "model": t.model,
                "attempt_number": t.attempt_number,
                "reasoning": t.reasoning,
            })
        path = triples_dir / f"{safe}_{datetime.now():%Y%m%d_%H%M%S}.json"
        path.write_text(json.dumps(data, indent=2), encoding="utf-8")

    def save_identifiers(self, path: Path | None = None) -> None:
        """Save confirmed identifiers for cross-run learning."""
        path = path or (self.output_dir / "confirmed_identifiers.json")
        self.tuner.save_identifiers(path)

    def load_identifiers(self, path: Path | None = None) -> None:
        """Load confirmed identifiers from previous runs."""
        path = path or (self.output_dir / "confirmed_identifiers.json")
        self.tuner.load_identifiers(path)
        n = len(self.tuner._confirmed_identifiers)
        if n:
            print(f"  Cross-theorem: loaded {n} confirmed identifiers")

    def _update_strategy_kb(
        self, item: 'ExtractedItem', translation: TranslationResult,
    ) -> None:
        """Extract a proof profile from a successful translation and add to KB."""
        if not translation.lean_code:
            return
        triple_dicts = [
            {
                "compiled": t.compiled,
                "compiler_output": t.compiler_output,
                "lean_code": t.lean_code,
                "model": t.model,
                "attempt_number": t.attempt_number,
            }
            for t in translation.triples
        ]
        from .agents.translator import detect_math_category
        cat_file = detect_math_category(item)
        domain = cat_file.replace(".md", "") if cat_file else ""

        profile = extract_proof_profile(
            lean_code=translation.lean_code,
            theorem_id=item.id,
            domain=domain,
            triples=triple_dicts,
        )
        self.strategy_kb.add(profile)

    def save_strategy_kb(self, path: Path | None = None) -> None:
        """Save the strategy knowledge base to JSON."""
        path = path or (self.output_dir / "knowledge_base.json")
        self.strategy_kb.save(path)
        print(f"  Strategy KB saved: {path} ({self.strategy_kb.size} profiles)")

    def load_strategy_kb(self, path: Path | None = None) -> None:
        """Load a strategy knowledge base from JSON."""
        path = path or (self.output_dir / "knowledge_base.json")
        if not path.exists():
            return
        self.strategy_kb.load(path)
        self.translator.strategy_kb = self.strategy_kb
        if self.strategy_kb.size > 0:
            print(f"  Strategy KB: loaded {self.strategy_kb.size} proof profiles")

    def load_knowledge(
        self,
        index_path: Path | None = None,
        kb_path: Path | None = None,
    ) -> None:
        """Load all knowledge sources: Mathlib index, Rosetta Stone, identifiers, strategy KB.

        Convenience method that calls load_mathlib_index, load_identifiers,
        and load_strategy_kb in sequence.
        """
        self.load_identifiers()
        if index_path or (self.output_dir / "rosetta_stone.jsonl").exists():
            self.load_mathlib_index(index_path)
        self.load_strategy_kb(kb_path)

    def load_mathlib_index(
        self,
        index_path: Path | None = None,
        extra_rosetta: list[Path] | Path | None = None,
    ) -> None:
        """Load a pre-built Mathlib declaration index for RAG-augmented translation.

        Also loads Rosetta Stone entries from the output directory if available.
        Pass ``extra_rosetta`` to load additional rosetta files (e.g. from
        prior runs like MWG) into the index before upgrading the librarian.
        If no index is loaded here, the translator still works — it just won't
        have Mathlib hints in its prompts.
        """
        if self.mathlib_index is None:
            self.mathlib_index = MathlibIndex(use_embeddings=False)
            self.translator.mathlib_index = self.mathlib_index
            self.translator.pre_compiler._index = self.mathlib_index

        if index_path and index_path.exists():
            self.mathlib_index.load(index_path)
            print(f"  Mathlib index: loaded {self.mathlib_index.size} declarations")

        # Load extra rosetta files (e.g. MWG consolidated corpus)
        if extra_rosetta:
            if isinstance(extra_rosetta, Path):
                extra_rosetta = [extra_rosetta]
            for rp in extra_rosetta:
                if rp.exists():
                    size_before = self.mathlib_index.size
                    self.mathlib_index.load_rosetta(rp)
                    n_new = self.mathlib_index.size - size_before
                    print(f"  Rosetta loaded: {n_new} entries from {rp.name}")

        # Also load Rosetta Stone entries from the output dir
        rosetta_path = self.output_dir / "rosetta_stone.jsonl"
        if rosetta_path.exists():
            size_before = self.mathlib_index.size
            self.mathlib_index.load_rosetta(rosetta_path)
            n_new = self.mathlib_index.size - size_before
            if n_new > 0:
                print(f"  Mathlib index: added {n_new} entries from Rosetta Stone")

        # Upgrade librarian with Rosetta Stone backend (TF-IDF over Mathlib +
        # verified proofs).  Keep the existing library as a fallback so that
        # batch-level InMemoryLibrary dedup still works.
        rosetta_lib = RosettaStoneLibrary(self.mathlib_index)
        self.librarian = LibrarianAgent(
            StackedLibrary([rosetta_lib, self.librarian.library])
        )
        print(f"  Librarian upgraded: RosettaStoneLibrary ({self.mathlib_index.size} declarations)")

    def save_inbox(self, path: Path) -> None:
        """Save inbox state to JSON."""
        self.inbox.save(path)
        print(f"  Inbox saved: {path} ({len(self.inbox.entries)} entries)")

    def load_inbox(self, path: Path) -> None:
        """Load inbox state from JSON."""
        self.inbox.load(path)
        if self.inbox.entries:
            print(f"  Inbox loaded: {len(self.inbox.entries)} entries")

    def save_backlog(self, path: Path) -> None:
        """Save backlog state to JSON."""
        data = {
            item_id: entry.model_dump(mode="json")
            for item_id, entry in self.backlog.entries.items()
        }
        path.parent.mkdir(parents=True, exist_ok=True)
        path.write_text(json.dumps(data, indent=2), encoding="utf-8")
        print(f"  Backlog saved: {path} ({len(data)} entries)")

    def load_backlog(self, path: Path) -> None:
        """Load backlog state from JSON."""
        if not path.exists():
            return
        data = json.loads(path.read_text(encoding="utf-8"))
        for item_id, entry_data in data.items():
            entry = BacklogEntry.model_validate(entry_data)
            self.backlog.entries[item_id] = entry
        # Migrate any old PENDING items to READY/BLOCKED
        self.backlog.resolve_all()
        print(f"  Backlog loaded: {len(data)} entries")

    def status(self) -> str:
        """Human-readable backlog + inbox summary."""
        # Inbox
        inbox_stats = self.inbox.stats
        inbox_total = sum(inbox_stats.values())
        lines = [f"Inbox: {inbox_total} items"]
        for s, count in sorted(inbox_stats.items()):
            lines.append(f"  {s}: {count}")

        # Backlog
        stats = self.backlog.stats
        total = sum(stats.values())
        lines.append(f"Backlog: {total} items")
        for s, count in sorted(stats.items()):
            lines.append(f"  {s}: {count}")
        return "\n".join(lines)


# ------------------------------------------------------------------
# CLI
# ------------------------------------------------------------------

def main():
    import argparse

    from .config import load_config, apply_config, roll_call

    parser = argparse.ArgumentParser(
        prog="leanknowledge",
        description="LeanKnowledge formalization pipeline",
    )
    parser.add_argument("--config", default=None,
                        help="Path to TOML config file (default: run_config.toml)")
    parser.add_argument("--yes", "-y", action="store_true",
                        help="Skip roll call confirmation prompt")
    parser.add_argument("--skip-roll-call", action="store_true",
                        help="Skip model roll call entirely")
    subparsers = parser.add_subparsers(dest="command", required=True)

    def add_common(p):
        p.add_argument("--lean-project", default=None,
                        help="Path to Lake project (for Mathlib)")
        p.add_argument("--backlog", default=None,
                        help="Path to backlog JSON file")
        p.add_argument("--inbox", default=None,
                        help="Path to inbox JSON file")
        p.add_argument("--output", default=None,
                        help="Output directory")
        p.add_argument("--mathlib-index", default=None,
                        help="Path to Mathlib declaration index JSON")

    # extract
    ext = subparsers.add_parser("extract", help="Extract claims from PDF → backlog")
    ext.add_argument("--pdf", required=True, help="Path to PDF file")
    ext.add_argument("--start-page", type=int, required=True)
    ext.add_argument("--end-page", type=int, required=True)
    ext.add_argument("--source", default="", help="Source label")
    add_common(ext)

    # next
    nxt = subparsers.add_parser("next", help="Formalize next pending theorem")
    add_common(nxt)

    # run
    run = subparsers.add_parser("run", help="Formalize all pending theorems")
    run.add_argument("--retry", action="store_true",
                     help="Run failure analysis and retry after initial pass")
    run.add_argument("--retry-cycles", type=int, default=2,
                     help="Max retry cycles (default: 2)")
    run.add_argument("--retry-llm", action="store_true",
                     help="Use LLM for enhanced failure analysis")
    add_common(run)

    # retry (standalone — analyze failures and retry without re-running)
    retry_parser = subparsers.add_parser(
        "retry", help="Analyze failures from a previous run and retry",
    )
    retry_parser.add_argument("--cycles", type=int, default=2,
                              help="Max retry cycles (default: 2)")
    retry_parser.add_argument("--use-llm", action="store_true",
                              help="Use LLM for enhanced failure analysis")
    add_common(retry_parser)

    # status
    st = subparsers.add_parser("status", help="Show backlog status")
    add_common(st)

    # promote
    prom = subparsers.add_parser("promote", help="Re-screen inbox items against library")
    prom.add_argument("--rescreen", action="store_true",
                       help="Also re-screen already-promoted items")
    add_common(prom)

    # feed
    feed_parser = subparsers.add_parser("feed", help="Ingest PDFs/text into backlog")
    feed_group = feed_parser.add_mutually_exclusive_group(required=True)
    feed_group.add_argument("--dir", default=None,
                            help="Process all PDFs/text in directory")
    feed_group.add_argument("--file", default=None,
                            help="Process a single file (PDF or text)")
    feed_group.add_argument("--text", default=None,
                            help="Process a text file")
    feed_group.add_argument("--watch", default=None,
                            help="Watch directory for new files")
    feed_parser.add_argument("--formalize", action="store_true",
                             help="Auto-formalize after ingestion")
    feed_parser.add_argument("--recursive", action="store_true",
                             help="Scan directories recursively")
    feed_parser.add_argument("--chunk-pages", type=int, default=20,
                             help="Pages per extraction chunk (default 20)")
    feed_parser.add_argument("--interval", type=float, default=30.0,
                             help="Watch poll interval in seconds (default 30)")
    add_common(feed_parser)

    # dashboard (lightweight — does not instantiate the full pipeline)
    dash = subparsers.add_parser(
        "dashboard",
        help="Show pipeline statistics dashboard (no LLM required)",
    )
    dash.add_argument(
        "output_dir", nargs="?", default=None,
        help="Output directory to analyze (default: outputs/)",
    )

    # build-kb (lightweight — does not instantiate the full pipeline)
    build_kb = subparsers.add_parser(
        "build-kb",
        help="Build strategy knowledge base from Rosetta Stone + triples",
    )
    build_kb.add_argument(
        "output_dir", nargs="?", default=None,
        help="Output directory containing rosetta_stone.jsonl and triples/ "
             "(default: outputs/)",
    )

    # scan-axioms (lightweight — does not instantiate the full pipeline)
    scan_ax = subparsers.add_parser(
        "scan-axioms",
        help="Scan compiled Lean files for resolvable axioms",
    )
    scan_ax.add_argument(
        "--chapters", type=str, default=None,
        help="Comma-separated chapter numbers (default: all)",
    )
    scan_ax.add_argument(
        "--rosetta", type=str, default=None,
        help="Path to consolidated rosetta JSONL",
    )

    args = parser.parse_args()

    # --- Load config (before any imports that read env vars) ---
    config_path = Path(args.config) if args.config else (PROJECT_ROOT / "run_config.toml")
    cfg = load_config(config_path if config_path.exists() else None)
    apply_config(cfg)

    # --- Roll call for commands that spend LLM tokens ---
    _llm_commands = {"extract", "next", "run", "retry", "feed"}
    if args.command in _llm_commands and not args.skip_roll_call:
        all_ok = roll_call(cfg)
        if not args.yes:
            if not all_ok:
                print("  Some models failed. Fix configuration or use --yes to proceed anyway.")
            answer = input("\n  Proceed? [Y/n] ").strip().lower()
            if answer and answer != "y":
                print("  Aborted.")
                return

    # --- scan-axioms command: skip heavy pipeline init ---
    if args.command == "scan-axioms":
        output_path = Path(args.output) if hasattr(args, 'output') and args.output else (PROJECT_ROOT / "outputs")
        rosetta_path = Path(args.rosetta) if args.rosetta else output_path / "rosetta_consolidated.jsonl"
        if not rosetta_path.exists():
            # Fall back to chapter-local rosetta
            rosetta_path = output_path / "rosetta_stone.jsonl"
        from .mathlib_index import MathlibIndex as _MI
        from .agents.axiom_resolver import scan_directory as _scan_dir, format_report as _fmt, ResolutionReport as _RR
        index = _MI(rosetta_path=rosetta_path if rosetta_path.exists() else None, use_embeddings=False)
        print(f"Index loaded: {index.size} declarations")
        combined = _RR()
        # Find lean dirs
        if args.chapters:
            ch_nums = [int(c.strip()) for c in args.chapters.split(",")]
            dirs = [(output_path / f"mwg_ch{c}" / "lean", f"ch{c}") for c in ch_nums]
        else:
            dirs = []
            for d in sorted(output_path.iterdir()):
                if d.is_dir() and (d.name.startswith("mwg_ch") or d.name == "mwg_appendix"):
                    lean_d = d / "lean"
                    if lean_d.exists():
                        dirs.append((lean_d, d.name))
        for lean_dir, label in dirs:
            if not lean_dir.exists():
                continue
            print(f"Scanning {label}...", end=" ", flush=True)
            report = _scan_dir(lean_dir, index)
            print(f"{report.total_axioms} axioms")
            combined.total_files += report.total_files
            combined.files_with_axioms += report.files_with_axioms
            combined.total_axioms += report.total_axioms
            combined.mathlib_exact.extend(report.mathlib_exact)
            combined.rosetta_exact.extend(report.rosetta_exact)
            combined.partial.extend(report.partial)
            combined.unresolved.extend(report.unresolved)
        print(_fmt(combined))
        return

    # --- dashboard command: skip heavy pipeline init ---
    if args.command == "dashboard":
        from .dashboard import run_dashboard
        output_path = Path(args.output_dir) if args.output_dir else (PROJECT_ROOT / "outputs")
        print(run_dashboard(output_path))
        return

    # --- build-kb command: skip heavy pipeline init ---
    if args.command == "build-kb":
        output_path = Path(args.output_dir) if args.output_dir else (PROJECT_ROOT / "outputs")
        rosetta_path = output_path / "rosetta_stone.jsonl"
        triples_dir = output_path / "triples"
        if not rosetta_path.exists():
            print(f"No rosetta_stone.jsonl found at {rosetta_path}")
            return
        print(f"Building strategy KB from {rosetta_path}...")
        kb = build_from_rosetta(
            rosetta_path,
            triples_dir if triples_dir.exists() else None,
        )
        kb_path = output_path / "knowledge_base.json"
        kb.save(kb_path)
        print(f"Strategy KB built: {kb.size} proof profiles → {kb_path}")
        # Print summary stats
        if kb.size > 0:
            from collections import Counter as _Counter
            domains = _Counter(p.domain for p in kb._profiles if p.domain)
            print(f"\nDomain distribution:")
            for domain, count in domains.most_common(10):
                print(f"  {domain}: {count}")
        return

    pipeline = Pipeline(
        lean_project_dir=Path(args.lean_project) if args.lean_project else None,
        output_dir=Path(args.output) if args.output else None,
    )

    backlog_path = Path(args.backlog) if args.backlog else (PROJECT_ROOT / "backlog.json")
    inbox_path = Path(args.inbox) if args.inbox else (PROJECT_ROOT / "inbox.json")
    pipeline.load_backlog(backlog_path)
    pipeline.load_inbox(inbox_path)

    # Load confirmed identifiers, Mathlib index, and strategy KB
    pipeline.load_identifiers()  # from output dir if exists
    mathlib_index_path = Path(args.mathlib_index) if args.mathlib_index else None
    if mathlib_index_path or (pipeline.output_dir / "rosetta_stone.jsonl").exists():
        pipeline.load_mathlib_index(mathlib_index_path)
    pipeline.load_strategy_kb()  # from output dir if exists

    if args.command == "extract":
        pipeline.extract(
            Path(args.pdf), args.start_page, args.end_page, args.source,
        )
        pipeline.save_inbox(inbox_path)
        pipeline.save_backlog(backlog_path)

    elif args.command == "next":
        result = pipeline.formalize_next()
        pipeline.save_inbox(inbox_path)
        pipeline.save_backlog(backlog_path)
        pipeline.save_identifiers()
        pipeline.save_strategy_kb()
        if result and not result.success:
            exit(1)

    elif args.command == "run":
        results = pipeline.formalize_all()
        if args.retry:
            retry_results = pipeline.analyze_and_retry(
                max_cycles=args.retry_cycles,
                use_llm=args.retry_llm,
            )
            results.extend(retry_results)
        pipeline.save_inbox(inbox_path)
        pipeline.save_backlog(backlog_path)
        pipeline.save_identifiers()
        pipeline.save_strategy_kb()
        if any(not r.success for r in results):
            exit(1)

    elif args.command == "retry":
        results = pipeline.analyze_and_retry(
            max_cycles=args.cycles,
            use_llm=args.use_llm,
        )
        pipeline.save_inbox(inbox_path)
        pipeline.save_backlog(backlog_path)
        pipeline.save_identifiers()
        pipeline.save_strategy_kb()
        if any(not r.success for r in results):
            exit(1)

    elif args.command == "status":
        print(pipeline.status())

    elif args.command == "promote":
        n = pipeline.promote(rescreen=args.rescreen)
        print(f"Promoted {n} items")
        pipeline.save_inbox(inbox_path)
        pipeline.save_backlog(backlog_path)

    elif args.command == "feed":
        from .feeder import Feeder

        feeder = Feeder(
            pipeline,
            chunk_pages=args.chunk_pages,
            auto_formalize=args.formalize,
        )

        if args.dir:
            feeder.feed_directory(Path(args.dir), recursive=args.recursive)
        elif args.file:
            feeder.feed_file(Path(args.file))
        elif args.text:
            text_content = Path(args.text).read_text(encoding="utf-8")
            feeder.feed_text(text_content, source_label=Path(args.text).stem)
        elif args.watch:
            feeder.watch(Path(args.watch), interval=args.interval)

        pipeline.save_inbox(inbox_path)
        pipeline.save_backlog(backlog_path)
