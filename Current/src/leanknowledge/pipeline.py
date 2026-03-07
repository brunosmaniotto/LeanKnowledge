"""Pipeline orchestrator — chains agents 1-6 and manages the work queue.

Two main paths:
  Ingest:     PDF/text → claims → triage → librarian → backlog
  Formalize:  backlog → proof structurer → translator → Lean 4 output

Training data (translation triples) is collected from every attempt.
"""

import json
from dataclasses import dataclass, field
from datetime import datetime
from pathlib import Path

from .agents.extraction import ExtractionAgent
from .agents.claim_extraction import ClaimExtractionAgent
from .agents.triage import TriageAgent, ItemCategory
from .agents.librarian import LibrarianAgent, Library, InMemoryLibrary
from .agents.proof_structurer import ProofStructurer
from .agents.translator import TranslatorAgent, TranslationResult, TranslationOutcome
from .backlog import Backlog, BacklogEntry, BacklogStatus
from .lean.compiler import RealLeanCompiler
from .prompt_tuner import PromptTuner
from .schemas import ExtractionResult

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
    ):
        self.output_dir = output_dir or (PROJECT_ROOT / "outputs")

        # Prompt Tuner — learns from failures across the run
        self.tuner = PromptTuner()

        # Agents
        self.extraction = ExtractionAgent()
        self.claim_extraction = ClaimExtractionAgent()
        self.triage = TriageAgent()
        self.librarian = LibrarianAgent(library or InMemoryLibrary())
        self.structurer = ProofStructurer()
        self.compiler = RealLeanCompiler(project_dir=lean_project_dir)
        self.translator = TranslatorAgent(compiler=self.compiler, tuner=self.tuner)

        # State
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
        """Triage → Librarian → backlog."""
        inbox = self.triage.triage(result)
        lib_result = self.librarian.check(inbox)

        for verdict in lib_result.to_backlog:
            entry = BacklogEntry(
                item=verdict.item.item,
                category=verdict.item.category,
            )
            self.backlog.add(entry)

        stats = self.backlog.stats
        print(f"  Backlog: {stats}")

    # ------------------------------------------------------------------
    # Formalization path
    # ------------------------------------------------------------------

    def formalize_next(self) -> PipelineResult | None:
        """Pick next ready theorem → Agent 5 → Agent 6 → update backlog."""
        ready = [
            e for e in self.backlog.ready()
            if e.category == ItemCategory.THEOREM
        ]
        if not ready:
            n_blocked = len([
                e for e in self.backlog.blocked()
                if e.category == ItemCategory.THEOREM
            ])
            if n_blocked:
                print(f"No ready theorems ({n_blocked} blocked on dependencies).")
            else:
                print("No ready theorems in backlog.")
            return None

        return self.formalize_entry(ready[0])

    def formalize_all(self) -> list[PipelineResult]:
        """Formalize all pending theorems sequentially."""
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

    def formalize_entry(self, entry: BacklogEntry) -> PipelineResult:
        """Formalize a specific backlog entry through Agent 5 → Agent 6."""
        item = entry.item
        print(f"\n=== Formalize: {item.id} ===\n")

        self.backlog.mark_in_progress(item.id)

        try:
            # Agent 5: NL proof → structured proof plan
            proof = self.structurer.structure(item)

            # Agent 6: structured proof → Lean 4 code
            translation = self.translator.translate(proof)

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
                print(f"=== SUCCESS: {item.id} "
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
            print(f"=== ERROR: {item.id} — {e} ===")
            return PipelineResult(item_id=item.id, success=False, error=str(e))

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
            })
        path = triples_dir / f"{safe}_{datetime.now():%Y%m%d_%H%M%S}.json"
        path.write_text(json.dumps(data, indent=2), encoding="utf-8")

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
        """Human-readable backlog summary."""
        stats = self.backlog.stats
        total = sum(stats.values())
        lines = [f"Backlog: {total} items"]
        for s, count in sorted(stats.items()):
            lines.append(f"  {s}: {count}")
        return "\n".join(lines)


# ------------------------------------------------------------------
# CLI
# ------------------------------------------------------------------

def main():
    import argparse

    parser = argparse.ArgumentParser(
        prog="leanknowledge",
        description="LeanKnowledge formalization pipeline",
    )
    subparsers = parser.add_subparsers(dest="command", required=True)

    def add_common(p):
        p.add_argument("--lean-project", default=None,
                        help="Path to Lake project (for Mathlib)")
        p.add_argument("--backlog", default=None,
                        help="Path to backlog JSON file")
        p.add_argument("--output", default=None,
                        help="Output directory")

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
    add_common(run)

    # status
    st = subparsers.add_parser("status", help="Show backlog status")
    add_common(st)

    args = parser.parse_args()

    pipeline = Pipeline(
        lean_project_dir=Path(args.lean_project) if args.lean_project else None,
        output_dir=Path(args.output) if args.output else None,
    )

    backlog_path = Path(args.backlog) if args.backlog else (PROJECT_ROOT / "backlog.json")
    pipeline.load_backlog(backlog_path)

    if args.command == "extract":
        pipeline.extract(
            Path(args.pdf), args.start_page, args.end_page, args.source,
        )
        pipeline.save_backlog(backlog_path)

    elif args.command == "next":
        result = pipeline.formalize_next()
        pipeline.save_backlog(backlog_path)
        if result and not result.success:
            exit(1)

    elif args.command == "run":
        results = pipeline.formalize_all()
        pipeline.save_backlog(backlog_path)
        if any(not r.success for r in results):
            exit(1)

    elif args.command == "status":
        print(pipeline.status())
