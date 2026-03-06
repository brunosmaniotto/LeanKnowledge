"""Pipeline orchestrator — chains all stages and manages training data collection.

The backlog is the central work queue. Items flow through:
  Extract → Backlog → Formalize (Stages 1-4) → Training data
"""

import json
import re
from datetime import datetime
from pathlib import Path

from .schemas import (
    TheoremInput,
    StructuredProof,
    VerificationResult,
    ResolverResult,
    PipelineResult,
    TrainingPair,
    ExtractionResult,
    BacklogEntry,
    KnowledgeNode,
    LeanCode,
    Domain,
    BacklogStatus,
)
from .backlog import Backlog
from .router import Router
from .agents.extraction import ExtractionAgent
from .agents.proof import ProofAgent
from .agents.translator import TranslatorAgent
from .agents.verifier import Verifier
from .agents.knowledge import KnowledgeAgent
from .agents.resolver import ResolverAgent
from .agents.librarian import LibrarianAgent
from .agents.feeder import FeederAgent
from .citation_suggestions import CitationSuggester
from .librarian_index import LibrarianIndex
from .embedding_index import EmbeddingIndex
from .sources.proofwiki import (
    scan_archive,
    parse_page,
    catalog_stats,
    CatalogEntry,
    PROVABLE,
)
from .lean.compiler import LeanCompiler
from .strategy_kb import StrategyKB, StrategyEntry
from .claude_client import usage_tracker

PROJECT_ROOT = Path(__file__).resolve().parents[2]
TRAINING_DATA_DIR = PROJECT_ROOT / "training_data"
OUTPUTS_DIR = PROJECT_ROOT / "outputs"
EXTRACTIONS_DIR = PROJECT_ROOT / "outputs" / "extractions"
AXIOMS_FILE = PROJECT_ROOT / "LeanProject" / "Axioms.lean"
PROOFWIKI_DIR = PROJECT_ROOT / "Sources" / "ProofWiki"

AXIOMS_HEADER = """\
/-! # Axiomatized Theorems
These theorems were accepted without proof because formalization failed.
They can be replaced with proved versions later. -/
"""


class Pipeline:
    def __init__(self, lean_project_dir: Path | None = None, backlog_path: Path | None = None):
        self.extraction_agent = ExtractionAgent()
        self.proof_agent = ProofAgent()
        self.strategy_kb = StrategyKB(path=PROJECT_ROOT / "strategy_kb.json")
        self.translator = TranslatorAgent(strategy_kb=self.strategy_kb)
        self.compiler = LeanCompiler(project_dir=lean_project_dir)
        self.verifier = Verifier(self.compiler, self.translator, self.proof_agent, self.strategy_kb)
        self.resolver = ResolverAgent(self.compiler)
        self.knowledge_agent = KnowledgeAgent()
        self.librarian_index = LibrarianIndex()
        self.embedding_index = EmbeddingIndex()
        self.librarian = LibrarianAgent(
            index=self.librarian_index,
            embedding_index=self.embedding_index,
        )
        self.backlog = Backlog(path=backlog_path or (PROJECT_ROOT / "backlog.json"))
        self.router = Router(self.librarian, self.backlog)
        self.citation_suggester = CitationSuggester()
        self.feeder = FeederAgent(
            sources_dir=PROJECT_ROOT / "Sources",
            citation_suggester=self.citation_suggester,
        )

    # --- Stage 0: Extract and populate backlog ---

    def feed_blocked(self, max_items: int = 10) -> int:
        """Try to find sources for blocked backlog items. Returns count found."""
        feedable = self.backlog.get_feedable(limit=max_items)
        if not feedable:
            print("No feedable blocked items.")
            return 0

        print(f"\n=== Feeder: processing {len(feedable)} blocked items ===")
        results = self.feeder.process_backlog(feedable, max_items=max_items)

        found_count = 0
        for entry, result in zip(feedable, results):
            if result.found:
                found_count += 1
                print(f"  [feeder] Found source for {entry.item.id}: {result.source_type}")
                if result.source_type == "pdf_page" and result.source_path:
                    if result.page_range:
                        # Auto-extract from the found source
                        try:
                            start, end = result.page_range
                            self.extract(
                                result.source_path, start, end,
                                entry.domain, source_label=f"Feeder:{entry.item.id}"
                            )
                        except Exception as e:
                            print(f"  [feeder] Auto-extract failed: {e}")
                    else:
                        print(f"  [feeder] Source found ({result.source_path.name}) but no page range — manual extraction needed")
                elif result.source_type == "mathlib_source":
                    # The dependency exists in Mathlib — mark the blocked dep as resolved
                    # This unblocks the parent item
                    for dep_id in entry.item.dependencies:
                        dep_entry = self.backlog.get_entry(dep_id)
                        if dep_entry and dep_entry.status == BacklogStatus.BLOCKED:
                            self.backlog.mark_completed(dep_id, lean_file=f"Mathlib:{result.notes or 'found'}")
                            print(f"  [feeder] Marked dependency {dep_id} as Mathlib-resolved")
            else:
                print(f"  [feeder] No source found for {entry.item.id}: {result.notes}")

        print(f"\n  Feeder found sources for {found_count}/{len(feedable)} items")
        print(self.backlog.summary())
        return found_count

    def extract(
        self,
        pdf_path: Path,
        start_page: int,
        end_page: int,
        domain: Domain,
        source_label: str = "",
    ) -> ExtractionResult:
        """Extract items from PDF and add them to the backlog."""
        print(f"=== Extraction: {pdf_path.name} pp.{start_page}-{end_page} ===\n")

        result = self.extraction_agent.extract_from_pdf(
            pdf_path, start_page, end_page, source_label
        )

        print(f"  Source: {result.source}")
        print(f"  Items extracted: {len(result.items)}")
        
        # Route items through Librarian and Backlog
        self.router.route(result.items, domain, result.source)

        # Save raw extraction
        self._save_extraction(result)

        print(f"\n  Backlog updated via Router")
        print(self.backlog.summary())

        return result

    def ingest_proofwiki_batch(
        self,
        catalog_path: Path | None = None,
        limit: int | None = None,
        domain_filter: Domain | None = None,
        archive_dir: Path = PROOFWIKI_DIR,
    ) -> int:
        """Batch-ingest ProofWiki items into the backlog. Returns count added."""
        # Load or build catalog
        catalog_file = catalog_path or (archive_dir / "catalog.json")
        if catalog_file.exists():
            raw = json.loads(catalog_file.read_text(encoding="utf-8"))
            entries = [CatalogEntry(**e) for e in raw]
            print(f"  Loaded catalog: {len(entries)} entries")
        else:
            print("  No catalog found — running scanner first...")
            entries = scan_archive(archive_dir)

        # Filter to provable items
        provable = [e for e in entries if e.classification in PROVABLE]
        print(f"  Provable items: {len(provable)}")

        # Optionally filter by domain
        if domain_filter:
            provable = [e for e in provable if e.detected_domain == domain_filter.value]
            print(f"  After domain filter ({domain_filter.value}): {len(provable)}")

        # Apply limit
        if limit:
            provable = provable[:limit]

        added = 0
        skipped = 0
        errors = 0

        for i, entry in enumerate(provable):
            item_id = f"ProofWiki:{entry.title}"

            # Skip if already in backlog
            if self.backlog.get_entry(item_id):
                skipped += 1
                continue

            # Load and parse the page
            page_path = archive_dir / entry.file_path
            try:
                data = json.loads(page_path.read_text(encoding="utf-8"))
                wikitext = data.get("wikitext", "")
                item = parse_page(entry.title, wikitext, archive_dir)
                domain = Domain(entry.detected_domain)
                self.backlog.add_item(item, f"ProofWiki:{entry.title}", domain)
                added += 1
            except Exception as e:
                errors += 1
                if errors <= 5:
                    print(f"  [pw-ingest] Error parsing {entry.title}: {e}")

            if (i + 1) % 100 == 0:
                print(f"  [pw-ingest] Progress: {i + 1}/{len(provable)} "
                      f"(added={added}, skipped={skipped}, errors={errors})")

        print(f"\n  Batch ingest complete: {added} added, {skipped} already in backlog, {errors} errors")
        return added

    # --- Process backlog: formalize next ready item ---

    def formalize_next(self) -> PipelineResult | None:
        """Pull the next ready item from the backlog and formalize it."""
        entry = self.backlog.next()
        if entry is None:
            print("Nothing ready in backlog.")
            blocked = self.backlog.get_blocked()
            if blocked:
                print(f"  {len(blocked)} items blocked on dependencies")
            return None

        return self.formalize_entry(entry)

    def formalize_all_ready(self) -> list[PipelineResult]:
        """Formalize all ready items in the backlog, in dependency order."""
        results = []
        while True:
            entry = self.backlog.next()
            if entry is None:
                break
            result = self.formalize_entry(entry)
            results.append(result)

        successes = sum(1 for r in results if r.success)
        print(f"\n{'='*60}")
        print(f"Batch complete: {successes}/{len(results)} formalized successfully")

        # After formalizing all ready items, try to unblock more
        blocked = self.backlog.get_blocked()
        if blocked:
            print(f"\n{len(blocked)} items still blocked. Running Feeder...")
            self.feed_blocked(max_items=10)

        print(self.backlog.summary())
        print(f"{'='*60}")

        return results

    def formalize_entry(self, entry: BacklogEntry) -> PipelineResult:
        """Formalize a specific backlog entry."""
        self.backlog.mark_in_progress(entry.item.id)

        theorem_input = TheoremInput(
            name=entry.item.id,
            statement=entry.item.statement,
            domain=entry.domain,
            source=entry.source,
        )

        result = self.run(theorem_input)

        if result.success:
            lean_file = f"{entry.item.id.lower().replace(' ', '_')}.lean"
            self.backlog.mark_completed(entry.item.id, lean_file=lean_file)
        else:
            reason = ""
            if result.verification and result.verification.errors:
                reason = result.verification.errors[0].message
            self.backlog.mark_failed(entry.item.id, reason=reason)
            self._axiomatize_failed(entry, theorem_input)

        return result

    # --- Stages 1-4: Core formalization ---

    def run(self, theorem: TheoremInput) -> PipelineResult:
        """Run the full formalization pipeline on a single theorem."""
        usage_tracker.reset()
        print(f"=== LeanKnowledge: {theorem.name} ===\n")

        # Stage 1: Generate structured NL proof
        print("[Stage 1] Generating structured proof...")
        strategy_hints = self._build_strategy_hints(theorem)
        proof = self.proof_agent.generate(theorem, strategy_hints=strategy_hints)
        print(f"  Strategy: {proof.strategy.value}")
        print(f"  Dependencies: {', '.join(proof.dependencies) or 'none'}")
        print(f"  Steps: {len(proof.steps)}")

        # Stage 2: Translate to Lean
        print("\n[Stage 2] Translating to Lean 4...")
        tactic_hints = self._build_tactic_hints(proof)
        lean_code = self.translator.translate(proof, tactic_hints=tactic_hints)
        print(f"  Imports: {', '.join(lean_code.imports) or 'none'}")
        print(f"  Code length: {len(lean_code.code)} chars")

        # Stage 3: Verification loop
        print("\n[Stage 3] Verifying...")
        result = self.verifier.verify(lean_code, proof, theorem)
        print(f"  Success: {result.success}")
        print(f"  Iterations: {result.iterations}")
        if result.escalated_to_proof_agent:
            print("  (Escalated to proof agent for strategy revision)")

        # Stage 4: Knowledge integration (only on success)
        knowledge = None
        if result.success:
            print("\n[Stage 4] Building knowledge node...")
            knowledge = self.knowledge_agent.analyze(theorem, proof, result.lean_code)
            print(f"  Tags: {', '.join(knowledge.tags)}")
            print(f"  Lean deps: {', '.join(knowledge.lean_dependencies) or 'none'}")

            self._write_strategy_entry(theorem, proof, result, knowledge)
            self._save_training_pair(theorem, proof, result)
            self._save_lean_output(theorem, result.lean_code)
        else:
            self._save_failure_triple(theorem, proof, result)

        pipeline_result = PipelineResult(
            success=result.success,
            theorem=theorem,
            proof=proof,
            verification=result,
            knowledge=knowledge,
        )

        status = "SUCCESS" if result.success else "FAILED"
        print(f"\n=== {status}: {theorem.name} ===")

        if not result.success and result.errors:
            print("Final errors:")
            for e in result.errors:
                print(f"  [{e.category.value}] {e.message}")

        print(f"\n[Cost] {usage_tracker.summary()}")

        return pipeline_result

    # --- Tier 2: Resolver — prove axiomatized theorems ---

    def resolve_next(self) -> ResolverResult | None:
        """Resolve the next axiomatized item using heavy-model reasoning."""
        axiomatized = self.backlog.get_axiomatized()
        if not axiomatized:
            print("No axiomatized items to resolve.")
            return None
        return self.resolve_entry(axiomatized[0])

    def resolve_all(self) -> list[ResolverResult]:
        """Resolve all axiomatized items."""
        results = []
        for entry in self.backlog.get_axiomatized():
            results.append(self.resolve_entry(entry))

        successes = sum(1 for r in results if r.success)
        print(f"\n{'='*60}")
        print(f"Resolve batch: {successes}/{len(results)} proved")
        print(self.backlog.summary())
        print(f"{'='*60}")

        return results

    def resolve_entry(self, entry: BacklogEntry) -> ResolverResult:
        """Attempt to prove a specific axiomatized entry."""
        usage_tracker.reset()
        print(f"\n=== Resolver: {entry.item.id} ===")
        self.backlog.mark_in_progress(entry.item.id)

        result = self.resolver.resolve(entry)

        if result.success:
            self._replace_axiom_with_proof(entry, result.lean_code)
            self.backlog.mark_completed(entry.item.id, lean_file="LeanProject/Axioms.lean")
            # Save as high-value training pair
            theorem = TheoremInput(
                name=entry.item.id,
                statement=entry.item.statement,
                domain=entry.domain,
                source=entry.source,
            )
            TRAINING_DATA_DIR.mkdir(parents=True, exist_ok=True)
            pair = TrainingPair(
                theorem=theorem,
                nl_proof=StructuredProof(
                    theorem_name=theorem.name,
                    strategy="direct",
                    assumptions=[],
                    dependencies=[],
                    steps=[],
                    conclusion=theorem.statement,
                ),
                lean_code=result.lean_code,
                iterations_needed=result.iterations,
            )
            filename = f"resolved_{theorem.name.lower().replace(' ', '_')}_{datetime.now():%Y%m%d_%H%M%S}.json"
            path = TRAINING_DATA_DIR / filename
            path.write_text(pair.model_dump_json(indent=2))
            print(f"  Training pair saved: {path.name}")
            print(f"=== RESOLVED: {entry.item.id} ===")
        else:
            self.backlog.restore_axiomatized(entry.item.id)
            print(f"=== UNRESOLVED: {entry.item.id} ===")
            if result.errors:
                for e in result.errors[:3]:
                    print(f"  [{e.category.value}] {e.message}")

        print(f"\n[Cost] {usage_tracker.summary()}")

        return result

    def _replace_axiom_with_proof(self, entry: BacklogEntry, proved_code: str):
        """Replace an axiom in Axioms.lean with a proved theorem."""
        if not AXIOMS_FILE.exists():
            print("  [resolver] Axioms.lean not found, skipping in-place replacement")
            return

        content = AXIOMS_FILE.read_text()

        # Find the block for this entry: -- [unproved] {id} ... followed by axiom declaration
        tag = f"-- [unproved] {entry.item.id}"
        if tag not in content:
            print(f"  [resolver] Tag '{tag}' not found in Axioms.lean, skipping replacement")
            return

        # Split into lines and find the tagged section
        lines = content.splitlines()
        tag_idx = None
        for i, line in enumerate(lines):
            if line.startswith(tag):
                tag_idx = i
                break

        if tag_idx is None:
            return

        # Find the axiom declaration block starting after the tag
        # It extends until the next comment tag, blank-line-then-comment, or end of file
        block_start = tag_idx
        block_end = tag_idx + 1
        while block_end < len(lines):
            line = lines[block_end]
            # Next entry marker or end of declarations
            if line.startswith("-- [unproved]") or line.startswith("-- [proved]"):
                break
            block_end += 1

        # Strip trailing blank lines from the block
        while block_end > block_start + 1 and not lines[block_end - 1].strip():
            block_end -= 1

        # Build replacement: update tag + insert proved code
        proved_tag = tag.replace("-- [unproved]", "-- [proved]")
        replacement_lines = [proved_tag, proved_code]

        new_lines = lines[:block_start] + replacement_lines + lines[block_end:]
        new_content = "\n".join(new_lines)

        # Merge any new imports the proof needs
        new_imports: set[str] = set()
        for line in proved_code.splitlines():
            m = re.match(r"^import\s+(.+)$", line)
            if m:
                new_imports.add(m.group(1).strip())

        if new_imports:
            # Collect existing imports from file
            existing_imports: set[str] = set()
            for line in new_content.splitlines():
                m = re.match(r"^import\s+(.+)$", line)
                if m:
                    existing_imports.add(m.group(1).strip())

            missing = new_imports - existing_imports
            if missing:
                import_block = "\n".join(f"import {imp}" for imp in sorted(missing))
                new_content = import_block + "\n" + new_content

        # Compile-check the updated file before writing
        test_code = LeanCode(code=new_content, imports=[])
        success, errors = self.compiler.compile(test_code)
        if success:
            AXIOMS_FILE.write_text(new_content)
            print(f"  [resolver] Replaced axiom with proof in {AXIOMS_FILE}")
        else:
            error_msgs = "; ".join(e.message for e in errors[:3])
            print(f"  [resolver] Proof breaks Axioms.lean: {error_msgs}")
            print(f"  [resolver] Writing proof to standalone file instead")
            standalone = OUTPUTS_DIR / f"resolved_{entry.item.id.lower().replace(' ', '_')}.lean"
            OUTPUTS_DIR.mkdir(parents=True, exist_ok=True)
            standalone.write_text(proved_code)

    # --- Auto-axiomatization of failures ---

    def _axiomatize_failed(self, entry: BacklogEntry, theorem: TheoremInput):
        """Attempt to axiomatize a failed theorem to unblock dependents."""
        print(f"\n[Axiomatize] Generating axiom for {theorem.name}...")
        try:
            axiom_code = self.translator.axiomatize(theorem)
        except Exception as e:
            print(f"  Axiom generation failed: {e}")
            return

        # Build the full axioms file with this new axiom appended
        merged = self._merge_axiom(axiom_code, entry)

        # Compile-check the whole axioms file
        success, errors = self.compiler.compile(merged)
        if success:
            AXIOMS_FILE.parent.mkdir(parents=True, exist_ok=True)
            full_code = "\n".join(f"import {imp}" for imp in merged.imports)
            if merged.imports:
                full_code += "\n\n"
            full_code += merged.code
            AXIOMS_FILE.write_text(full_code)
            self.backlog.mark_axiomatized(entry.item.id)
            print(f"  Axiomatized successfully → {AXIOMS_FILE}")
        else:
            error_msgs = "; ".join(e.message for e in errors[:3])
            print(f"  Axiom failed to compile: {error_msgs}")

    def _merge_axiom(self, axiom_code: LeanCode, entry: BacklogEntry) -> LeanCode:
        """Merge a new axiom into the existing Axioms.lean content."""
        # Read existing file or start fresh
        if AXIOMS_FILE.exists():
            existing = AXIOMS_FILE.read_text()
        else:
            existing = ""

        # Extract existing imports
        existing_imports: set[str] = set()
        body_lines: list[str] = []
        for line in existing.splitlines():
            m = re.match(r"^import\s+(.+)$", line)
            if m:
                existing_imports.add(m.group(1).strip())
            else:
                body_lines.append(line)

        # Merge imports (deduplicate)
        all_imports = sorted(existing_imports | set(axiom_code.imports))

        # Get existing body (strip leading blank lines)
        body = "\n".join(body_lines).strip()

        # If no existing body, start with the header
        if not body:
            body = AXIOMS_HEADER

        # Append new axiom with a comment header
        comment = f"-- [unproved] {entry.item.id}"
        if entry.source:
            comment += f" ({entry.source})"
        body += f"\n\n{comment}\n{axiom_code.code}"

        return LeanCode(code=body, imports=all_imports)

    # --- Persistence ---

    def _save_extraction(self, result: ExtractionResult):
        EXTRACTIONS_DIR.mkdir(parents=True, exist_ok=True)
        safe_name = result.source.lower().replace(" ", "_").replace("/", "_")
        filename = f"{safe_name}_{datetime.now():%Y%m%d_%H%M%S}.json"
        path = EXTRACTIONS_DIR / filename
        path.write_text(result.model_dump_json(indent=2))
        print(f"  Extraction saved: {path.name}")

    def _save_training_pair(self, theorem: TheoremInput, proof: StructuredProof, result: VerificationResult):
        TRAINING_DATA_DIR.mkdir(parents=True, exist_ok=True)
        pair = TrainingPair(
            theorem=theorem,
            nl_proof=proof,
            lean_code=result.lean_code,
            iterations_needed=result.iterations,
        )
        filename = f"{theorem.name.lower().replace(' ', '_')}_{datetime.now():%Y%m%d_%H%M%S}.json"
        path = TRAINING_DATA_DIR / filename
        path.write_text(pair.model_dump_json(indent=2))
        print(f"  Training pair saved: {path.name}")

    def _save_lean_output(self, theorem: TheoremInput, lean_code: str):
        OUTPUTS_DIR.mkdir(parents=True, exist_ok=True)
        filename = f"{theorem.name.lower().replace(' ', '_')}.lean"
        path = OUTPUTS_DIR / filename
        path.write_text(lean_code)
        print(f"  Lean file saved: {path.name}")

    def _save_failure_triple(self, theorem: TheoremInput, proof: StructuredProof, result: VerificationResult):
        """Save failure triple for training the failure classifier."""
        FAILURE_TRIPLES_DIR = TRAINING_DATA_DIR / "failure_triples"
        FAILURE_TRIPLES_DIR.mkdir(parents=True, exist_ok=True)
        
        triple = {
            "theorem_name": theorem.name,
            "nl_proof": proof.model_dump(mode="json"),
            "bad_lean_code": result.lean_code,
            "error_type": result.errors[0].category.value if result.errors else "unknown",
            "error_message": result.errors[0].message if result.errors else "Unknown error",
            "proof_strategy": proof.strategy.value,
            "timestamp": datetime.now().isoformat()
        }
        
        filename = f"{theorem.name.lower().replace(' ', '_')}_{datetime.now():%Y%m%d_%H%M%S}.json"
        path = FAILURE_TRIPLES_DIR / filename
        path.write_text(json.dumps(triple, indent=2))
        print(f"  Failure triple saved: {path.name}")

    def _build_tactic_hints(self, proof: StructuredProof) -> str:
        """Query Strategy KB for tactic patterns that worked for this proof strategy."""
        # Get tactic sequences that compiled for this strategy
        patterns = self.strategy_kb.tactic_patterns(proof.strategy.value)
        if not patterns:
            return ""

        # Count tactic frequency across successful proofs
        from collections import Counter
        tactic_freq = Counter()
        for seq in patterns[:50]:  # Cap to avoid huge prompts
            for tactic in seq:
                tactic_freq[tactic] += 1

        if not tactic_freq:
            return ""

        top_tactics = tactic_freq.most_common(10)
        lines = [f"Tactics that commonly succeed for '{proof.strategy.value}' proofs:"]
        for tactic, count in top_tactics:
            lines.append(f"- `{tactic}` (used in {count} successful proofs)")

        # Also get tactics from similar dependencies
        if proof.dependencies:
            dep_entries = self.strategy_kb.query_by_objects(proof.dependencies, top_k=5)
            if dep_entries:
                dep_tactics = set()
                for entry in dep_entries:
                    dep_tactics.update(entry.lean_tactics_used)
                if dep_tactics:
                    lines.append(f"\nTactics used in proofs with similar dependencies: {', '.join(list(dep_tactics)[:10])}")

        return "\n".join(lines)

    def _build_strategy_hints(self, theorem: TheoremInput) -> str:
        """Query Strategy KB for hints about what strategies work for this domain."""
        domain_entries = [e for e in self.strategy_kb.entries if e.domain == theorem.domain.value]
        if not domain_entries:
            return ""

        strategy_counts: dict[str, int] = {}
        strategy_successes: dict[str, int] = {}
        for entry in domain_entries:
            for strategy in entry.proof_strategies:
                strategy_counts[strategy] = strategy_counts.get(strategy, 0) + 1
                if entry.iterations_to_compile <= 3:
                    strategy_successes[strategy] = strategy_successes.get(strategy, 0) + 1

        if not strategy_counts:
            return ""

        lines = ["Based on past formalizations in this domain:"]
        for strategy, total in sorted(strategy_counts.items(), key=lambda x: -x[1]):
            successes = strategy_successes.get(strategy, 0)
            rate = successes / total
            lines.append(f"- '{strategy}': {rate:.0%} success ({successes}/{total} compiled in ≤3 iterations)")

        return "\n".join(lines)

    def _write_strategy_entry(
        self,
        theorem: TheoremInput,
        proof: StructuredProof,
        result: VerificationResult,
        knowledge: KnowledgeNode,
    ):
        """Record a successful formalization in the Strategy KB."""
        if result.iterations <= 2:
            difficulty = "easy"
        elif result.iterations <= 4:
            difficulty = "medium"
        else:
            difficulty = "hard"

        entry = StrategyEntry(
            theorem_id=theorem.name,
            domain=theorem.domain.value,
            mathematical_objects=proof.dependencies,
            proof_strategies=[proof.strategy.value],
            lean_tactics_used=[t for t in knowledge.tags if t != proof.strategy.value],
            lean_tactics_failed=[],
            difficulty=difficulty,
            iterations_to_compile=result.iterations,
            proof_revisions=1 if result.escalated_to_proof_agent else 0,
            error_types_encountered=[],
            dependencies_used=knowledge.lean_dependencies,
            source=theorem.source or "",
        )
        self.strategy_kb.add(entry)
        print(f"  Strategy KB: recorded entry for {theorem.name}")


def _configure_model(pipeline: "Pipeline", model: str | None):
    """Configure resolver (and optionally proof agent) model from CLI --model flag."""
    if not model:
        return
    if model == "deepseek":
        from .deepseek_client import call_deepseek
        pipeline.resolver.call_fn = call_deepseek
    else:
        from functools import partial
        from .claude_client import call_claude
        pipeline.resolver.call_fn = partial(call_claude, model=model)


def main():
    """CLI entry point."""
    import argparse

    parser = argparse.ArgumentParser(description="LeanKnowledge formalization pipeline")
    subparsers = parser.add_subparsers(dest="command", required=True)

    # Shared arguments
    def add_common_args(p):
        p.add_argument("--lean-project", default=None, help="Path to Lake project")
        p.add_argument("--backlog", default=None, help="Path to backlog.json")

    # Extract: read PDF → populate backlog
    extract_parser = subparsers.add_parser("extract", help="Extract items from PDF into the backlog")
    extract_parser.add_argument("--pdf", required=True, help="Path to PDF file")
    extract_parser.add_argument("--start-page", type=int, required=True, help="First page (1-indexed)")
    extract_parser.add_argument("--end-page", type=int, required=True, help="Last page (inclusive)")
    extract_parser.add_argument("--domain", required=True, choices=[d.value for d in Domain])
    extract_parser.add_argument("--source", default="", help="Source label")
    add_common_args(extract_parser)

    # Feed: find sources for blocked items
    feed_parser = subparsers.add_parser("feed", help="Find sources for blocked backlog items")
    feed_parser.add_argument("--max-items", type=int, default=10, help="Max blocked items to process")
    add_common_args(feed_parser)

    # Next: formalize the next ready item from the backlog
    next_parser = subparsers.add_parser("next", help="Formalize the next ready item from the backlog")
    add_common_args(next_parser)

    # Run: formalize all ready items
    run_parser = subparsers.add_parser("run", help="Formalize all ready items in the backlog")
    add_common_args(run_parser)

    # Status: show backlog state
    status_parser = subparsers.add_parser("status", help="Show backlog status")
    add_common_args(status_parser)

    # ProofWiki: scan archive → catalog.json
    pw_scan_parser = subparsers.add_parser("pw-scan", help="Scan ProofWiki archive and build catalog.json")
    pw_scan_parser.add_argument("--archive-dir", default=None, help="Path to Sources/ProofWiki/")
    add_common_args(pw_scan_parser)

    # ProofWiki: batch ingest from catalog
    pw_ingest_parser = subparsers.add_parser("pw-ingest", help="Batch-ingest ProofWiki items into backlog")
    pw_ingest_parser.add_argument("--limit", type=int, default=None, help="Max items to ingest")
    pw_ingest_parser.add_argument("--domain", default=None, choices=[d.value for d in Domain], help="Filter by domain")
    pw_ingest_parser.add_argument("--archive-dir", default=None, help="Path to Sources/ProofWiki/")
    add_common_args(pw_ingest_parser)

    # ProofWiki: stats
    pw_stats_parser = subparsers.add_parser("pw-stats", help="Show ProofWiki catalog statistics")
    pw_stats_parser.add_argument("--archive-dir", default=None, help="Path to Sources/ProofWiki/")
    add_common_args(pw_stats_parser)

    # Resolve: prove next axiomatized item with heavy model
    resolve_parser = subparsers.add_parser("resolve", help="Resolve next axiomatized item")
    resolve_parser.add_argument("--model", default=None, help="Model to use (e.g. 'deepseek' for DeepSeek-Prover-V2)")
    add_common_args(resolve_parser)

    # Resolve-all: prove all axiomatized items
    resolve_all_parser = subparsers.add_parser("resolve-all", help="Resolve all axiomatized items")
    resolve_all_parser.add_argument("--model", default=None, help="Model to use (e.g. 'deepseek' for DeepSeek-Prover-V2)")
    add_common_args(resolve_all_parser)

    # Formalize: single theorem (manual, bypasses backlog)
    formalize_parser = subparsers.add_parser("formalize", help="Formalize a single theorem (manual)")
    formalize_parser.add_argument("--name", required=True, help="Theorem name")
    formalize_parser.add_argument("--statement", required=True, help="Theorem statement")
    formalize_parser.add_argument("--domain", required=True, choices=[d.value for d in Domain])
    formalize_parser.add_argument("--source", default=None, help="Source reference")
    formalize_parser.add_argument("--prover", default=None, help="Prover backend: 'deepseek' for DeepSeek-Prover-V2")
    add_common_args(formalize_parser)

    # Build embeddings for librarian
    emb_parser = subparsers.add_parser("build-embeddings", help="Build embedding index for librarian search")
    add_common_args(emb_parser)

    # Migrate: JSON → SQLite
    migrate_parser = subparsers.add_parser("migrate", help="Migrate JSON files to SQLite")
    add_common_args(migrate_parser)

    args = parser.parse_args()

    lean_dir = Path(args.lean_project) if getattr(args, "lean_project", None) else None
    backlog_path = Path(args.backlog) if getattr(args, "backlog", None) else None
    pipeline = Pipeline(lean_project_dir=lean_dir, backlog_path=backlog_path)

    if args.command == "extract":
        pipeline.extract(
            Path(args.pdf), args.start_page, args.end_page,
            Domain(args.domain), args.source,
        )

    elif args.command == "feed":
        count = pipeline.feed_blocked(max_items=args.max_items)
        if count == 0:
            print("No sources found.")

    elif args.command == "next":
        result = pipeline.formalize_next()
        if result and not result.success:
            exit(1)

    elif args.command == "run":
        results = pipeline.formalize_all_ready()
        failures = sum(1 for r in results if not r.success)
        if failures:
            exit(1)

    elif args.command == "status":
        print(pipeline.backlog.summary())

    elif args.command == "pw-scan":
        archive = Path(args.archive_dir) if getattr(args, "archive_dir", None) else PROOFWIKI_DIR
        print(f"=== ProofWiki Scanner: {archive} ===\n")
        entries = scan_archive(archive)
        print(f"\n{catalog_stats(entries)}")

    elif args.command == "pw-ingest":
        archive = Path(args.archive_dir) if getattr(args, "archive_dir", None) else PROOFWIKI_DIR
        domain = Domain(args.domain) if getattr(args, "domain", None) else None
        print(f"=== ProofWiki Batch Ingest ===\n")
        count = pipeline.ingest_proofwiki_batch(
            limit=getattr(args, "limit", None),
            domain_filter=domain,
            archive_dir=archive,
        )
        print(f"\n{pipeline.backlog.summary()}")

    elif args.command == "pw-stats":
        archive = Path(args.archive_dir) if getattr(args, "archive_dir", None) else PROOFWIKI_DIR
        catalog_file = archive / "catalog.json"
        if catalog_file.exists():
            raw = json.loads(catalog_file.read_text(encoding="utf-8"))
            entries = [CatalogEntry(**e) for e in raw]
        else:
            print("No catalog.json found. Run 'pw-scan' first.")
            exit(1)
        print(catalog_stats(entries))

    elif args.command == "resolve":
        _configure_model(pipeline, getattr(args, "model", None))
        result = pipeline.resolve_next()
        if result and not result.success:
            exit(1)

    elif args.command == "resolve-all":
        _configure_model(pipeline, getattr(args, "model", None))
        results = pipeline.resolve_all()
        failures = sum(1 for r in results if not r.success)
        if failures:
            exit(1)

    elif args.command == "formalize":
        prover = getattr(args, "prover", None)
        if prover == "deepseek":
            from .deepseek_client import call_deepseek
            pipeline.proof_agent = ProofAgent(call_fn=call_deepseek)
        elif prover:
            from functools import partial
            from .claude_client import call_claude
            pipeline.proof_agent = ProofAgent(call_fn=partial(call_claude, model=prover))
        
        theorem = TheoremInput(
            name=args.name,
            statement=args.statement,
            domain=Domain(args.domain),
            source=args.source,
        )
        result = pipeline.run(theorem)
        if not result.success:
            exit(1)

    elif args.command == "build-embeddings":
        from .embedding_index import build_embeddings_cli
        build_embeddings_cli()

    elif args.command == "migrate":
        from .storage import migrate_json_to_sqlite
        migrate_json_to_sqlite()
