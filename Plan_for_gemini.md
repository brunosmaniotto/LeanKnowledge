# Gemini Task Plan — Phase 2: Integration, Speed, and Training

This document contains implementation task specs for Gemini CLI. Each task is self-contained: it describes the goal, the relevant source files, the interface contract, acceptance criteria, and any constraints. Claude Code writes the specs; Gemini implements; Claude Code reviews.

**Workflow**: For each task below, run Gemini in the project root:
```bash
gemini -p "Read Plan_for_gemini.md, section [TASK N]. Implement it. All file paths are relative to this project root." --yolo
```

---

## Phase 1 — Already Completed

These tasks have been implemented and verified. Listed for context only — skip to Task 1 below.

| Task | What | Who |
|------|------|-----|
| Strategy KB | `StrategyKB` class + seeding from 221k Rosetta Stone pairs + wired into Pipeline/ProofAgent/Verifier | Claude Code |
| SDK Migration | `claude_client.py` rewritten to use Anthropic Python SDK (was subprocess `claude -p`) | Gemini |
| `get_feedable()` | Method added to Backlog — filters blocked items for Feeder agent | Gemini |
| Nested test fix | `test_is_fundamental_failure` dedented to top-level in `test_errors.py` | Gemini |
| Prompt caching | System prompts wrapped with `cache_control: {"type": "ephemeral"}` — 90% off repeated input | Claude Code |
| Usage tracking | `UsageTracker` in `claude_client.py` — logs tokens, cache hits, and estimated cost per theorem | Claude Code |
| Trainer + Data Prep | QLoRA training script, data loader, data splitter, SLURM job | Gemini |
| BibTeX Index | `bib_index.py` — manual parser for Mathlib's `references.bib` (423 entries), searchable by author/title/key/fuzzy. 6 tests | Gemini |
| Feeder Agent | `agents/feeder.py` + `prompts/feeder.md` — procurement agent for blocked backlog items. Uses BibIndex, `caller=` tracking, 3 search strategies | Gemini |
| Eval Pipeline | `training/eval_translator.py` — loads adapter, generates completions, compiles with Lean, reports Pass@1/Pass@k | Gemini |
| Batch API | `submit_batch()` + `poll_batch()` in `claude_client.py` | Gemini |
| Structured Output | `call_claude()` uses `response_format` instead of appending schema to prompt | Gemini |
| RL Stub | `training/train_repair.py` — documented DPO architecture stub | Gemini |

### Current State of Key Files

- **`src/leanknowledge/claude_client.py`** (~378 LOC): Anthropic SDK, prompt caching, usage tracking, `caller=` labels, Batch API, structured output via `response_format`. Default model: `claude-sonnet-4-6`.
- **`src/leanknowledge/strategy_kb.py`** (168 LOC): `StrategyKB` + `StrategyEntry` dataclass. Lazy-loading, compact JSON, `bulk_add()`. Seeded with 221k entries from Rosetta Stone.
- **`src/leanknowledge/pipeline.py`** (~790 LOC): Orchestrator. Strategy KB wired into `_build_strategy_hints()` (feeds ProofAgent) and `_write_strategy_entry()` (writes after success). Verifier gets strategy_kb in constructor.
- **`src/leanknowledge/agents/verifier.py`** (233 LOC): Compile-repair loop. Uses `strategy_kb.query_by_error()` when escalating to proof agent.
- **`src/leanknowledge/agents/translator.py`** (152 LOC): NL→Lean translation. Does NOT currently receive Strategy KB hints.
- **`src/leanknowledge/agents/feeder.py`** (223 LOC): Procurement agent. NOT integrated into Router/Pipeline.
- **`src/leanknowledge/router.py`** (42 LOC): Routes extracted items. Does NOT invoke Feeder.
- **`src/leanknowledge/backlog.py`** (258 LOC): Has `get_feedable()`. 377 entries: 69 completed, 50 ready, 37 in_progress, 66 blocked, 5 failed, 2 axiomatized, 148 skipped.
- **`src/leanknowledge/lean/compiler.py`** (87 LOC): Cold-starts `lake env lean` per compilation. No persistent process.
- **`citation_graph/`**: 10 scripts building economics paper citation network via Semantic Scholar + OpenAlex. NOT connected to pipeline.
- **Tests**: `tests/test_*.py` — 9 test files covering backlog, schemas, errors, repair_db, router, bib_index, loogle, feeder, strategy_kb.

---

## Phase 2 Tasks

### TASK 1 — Integrate Feeder Agent into Pipeline

**Goal**: When the pipeline has no READY items but has BLOCKED items, automatically invoke the Feeder to find sources for blocked dependencies. This closes the loop: blocked items → Feeder finds source → extract from source → add to backlog → unblock dependents.

**Files to modify**:
- `src/leanknowledge/pipeline.py` — add `feed_blocked()` method and wire into `formalize_all_ready()`
- `src/leanknowledge/router.py` — no changes needed (Feeder works alongside Router, not inside it)

**Files to read for context**:
- `src/leanknowledge/agents/feeder.py` — the existing FeederAgent class
- `src/leanknowledge/backlog.py` — `get_feedable()` method returns prioritized blocked items
- `src/leanknowledge/schemas.py` — `BacklogEntry`, `BacklogStatus`, `FeederResult` (note: FeederResult is defined in feeder.py, not schemas.py)

**Implementation**:

1. In `Pipeline.__init__()`, add:
   ```python
   from .agents.feeder import FeederAgent
   self.feeder = FeederAgent(sources_dir=PROJECT_ROOT / "Sources")
   ```

2. Add a new method `Pipeline.feed_blocked()`:
   ```python
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
                   # Auto-extract from the found source
                   try:
                       start, end = result.page_range or (1, 5)
                       self.extract(
                           result.source_path, start, end,
                           entry.domain, source_label=f"Feeder:{entry.item.id}"
                       )
                   except Exception as e:
                       print(f"  [feeder] Auto-extract failed: {e}")
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
   ```

3. Wire into `formalize_all_ready()` — after the main formalization loop completes, check for blocked items and optionally feed them:
   ```python
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
   ```

4. Add CLI subcommand `feed` in `main()`:
   ```python
   # Feed: find sources for blocked items
   feed_parser = subparsers.add_parser("feed", help="Find sources for blocked backlog items")
   feed_parser.add_argument("--max-items", type=int, default=10, help="Max blocked items to process")
   add_common_args(feed_parser)
   ```
   And in the command dispatch:
   ```python
   elif args.command == "feed":
       count = pipeline.feed_blocked(max_items=args.max_items)
       if count == 0:
           print("No sources found.")
   ```

5. You will also need to import `BacklogStatus` in `pipeline.py` if not already imported (check — it IS in the schemas import list at the top).

**Acceptance criteria**:
- `leanknowledge feed` runs and processes blocked items
- `leanknowledge feed --max-items 5` limits to 5 items
- `leanknowledge run` now also calls Feeder after formalization loop
- No crashes when Feeder finds nothing (graceful "No feedable items" message)
- Existing tests still pass: `uv run pytest tests/`

**Constraints**:
- Do NOT modify `agents/feeder.py` itself — it works. Only wire it into `pipeline.py`.
- Do NOT modify `router.py` — Feeder runs separately from Router (Router processes extractions, Feeder resolves blocked items).
- Keep the `feed_blocked()` method self-contained so it can be called independently or as part of `formalize_all_ready()`.

---

### TASK 2 — Wire Strategy KB Tactic Hints into Translator

**Goal**: The Translator Agent currently has no access to Strategy KB. When translating a proof, it should receive hints about which Lean tactics have succeeded for similar theorems. This is expected to reduce compile iterations by ~10-20%.

**Files to modify**:
- `src/leanknowledge/agents/translator.py` — accept and use tactic hints
- `src/leanknowledge/pipeline.py` — pass Strategy KB to Translator, build tactic hints

**Files to read for context**:
- `src/leanknowledge/strategy_kb.py` — `tactic_patterns()` and `query_by_objects()` methods
- `src/leanknowledge/agents/proof.py` — pattern for how ProofAgent receives `strategy_hints`

**Implementation**:

1. Modify `TranslatorAgent.__init__()` to accept an optional strategy_kb:
   ```python
   class TranslatorAgent:
       def __init__(self, strategy_kb=None):
           self.strategy_kb = strategy_kb
           self._axiom_cache: dict[str, dict] = {}
           self._load_axiom_cache()
   ```

2. Modify `TranslatorAgent.translate()` to accept and inject tactic hints:
   ```python
   def translate(self, proof: StructuredProof, tactic_hints: str = "") -> LeanCode:
       system = PROMPT_PATH.read_text()
       prompt = (
           f"Theorem: {proof.theorem_name}\n"
           f"Strategy: {proof.strategy.value}\n"
           f"Assumptions: {', '.join(proof.assumptions)}\n"
           f"Dependencies: {', '.join(proof.dependencies)}\n\n"
           f"Proof steps:\n"
           + "\n".join(
               f"  {i+1}. {step.description} [{step.justification}]"
               for i, step in enumerate(proof.steps)
           )
           + f"\n\nConclusion: {proof.conclusion}"
       )
       if tactic_hints:
           prompt += f"\n\n## Tactic Guidance\n{tactic_hints}\n"

       data = call_claude(prompt, system=system, schema=LeanCode, caller="translator.translate")
       return LeanCode.model_validate(data)
   ```

3. In `Pipeline.__init__()`, pass strategy_kb to translator:
   ```python
   self.translator = TranslatorAgent(strategy_kb=self.strategy_kb)
   ```

4. In `Pipeline.run()`, build tactic hints and pass to translator. Replace the existing Stage 2 block:
   ```python
   # Stage 2: Translate to Lean
   print("\n[Stage 2] Translating to Lean 4...")
   tactic_hints = self._build_tactic_hints(proof)
   lean_code = self.translator.translate(proof, tactic_hints=tactic_hints)
   print(f"  Imports: {', '.join(lean_code.imports) or 'none'}")
   print(f"  Code length: {len(lean_code.code)} chars")
   ```

5. Add `_build_tactic_hints()` method to Pipeline:
   ```python
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
   ```

6. Also update the call to `self.translator.translate(current_proof)` inside `verifier.py` (line 112) — when the verifier escalates to proof agent and re-translates, it should also pass tactic hints. But since the Verifier doesn't have access to Pipeline's hint builder, the simplest approach is: **do nothing for now** in verifier.py. The Verifier's re-translation after proof revision is an error-recovery path, and the repair prompt already includes error context. Adding tactic hints there is a future enhancement.

**Acceptance criteria**:
- `TranslatorAgent` accepts optional `tactic_hints: str` in `translate()`
- Pipeline builds tactic hints from Strategy KB and passes them
- When Strategy KB has no relevant entries, empty string is passed (no crash)
- Existing tests still pass: `uv run pytest tests/`
- **Do NOT break** the Verifier's call to `self.translator.translate(current_proof)` on line 112 of verifier.py — that call should still work without tactic_hints (default `""`)

**Constraints**:
- Keep `tactic_hints` as an optional parameter with default `""` so all existing call sites continue to work
- Don't change the Translator's `repair()` or `axiomatize()` methods
- Cap the hints to avoid bloating the prompt (max 10 tactics, max 50 patterns sampled)

---

### TASK 3 — Fix CLAUDECODE Environment Variable in claude_client.py

**Goal**: When calling the Anthropic API from within a Claude Code session, the `CLAUDECODE` environment variable can interfere. The `rosetta_stone/generate.py` already handles this by unsetting it before subprocess calls, but `claude_client.py` does not. Since we migrated to the SDK (no subprocess), this is less critical — but we should still unset it to be safe, because the Anthropic SDK might inspect env vars or spawn child processes.

**Files to modify**:
- `src/leanknowledge/claude_client.py` — unset `CLAUDECODE` before API calls

**Implementation**:

At the top of `call_claude()`, before creating the client, add:
```python
# Unset CLAUDECODE to prevent interference when running inside Claude Code
os.environ.pop("CLAUDECODE", None)
```

This should go right after the `api_key` check (around line 246), before `client = Anthropic(api_key=api_key)`.

Also add it to `submit_batch()` (around line 118), before `client = Anthropic(api_key=api_key)`.

And `poll_batch()` (around line 174), before `client = Anthropic(api_key=api_key)`.

**Acceptance criteria**:
- `CLAUDECODE` is popped from `os.environ` in all three functions before creating the Anthropic client
- No functional change to API behavior
- Existing tests still pass

**Constraints**:
- Use `os.environ.pop("CLAUDECODE", None)` (not `del`, which would crash if not set)
- This is a 3-line change total. Don't over-engineer it.

---

### TASK 4 — Backlog Triage Script: Reset Stuck IN_PROGRESS Items

**Goal**: 37 backlog items are stuck in IN_PROGRESS status from interrupted runs. Create a utility script that resets them to READY (if dependencies are met) or BLOCKED (if not).

**Files to create**:
- `scripts/triage_backlog.py`

**Files to read for context**:
- `src/leanknowledge/backlog.py` — Backlog class, `_refresh_statuses()` method
- `src/leanknowledge/schemas.py` — `BacklogStatus` enum

**Implementation**:

```python
#!/usr/bin/env python3
"""Triage stuck backlog items — reset IN_PROGRESS back to PENDING so dependency
refresh can move them to READY or BLOCKED."""

import argparse
import sys
from pathlib import Path

# Add project root to path
sys.path.insert(0, str(Path(__file__).resolve().parents[1] / "src"))

from leanknowledge.backlog import Backlog
from leanknowledge.schemas import BacklogStatus


def main():
    parser = argparse.ArgumentParser(description="Reset stuck IN_PROGRESS backlog items")
    parser.add_argument("--backlog", default="backlog.json", help="Path to backlog.json")
    parser.add_argument("--dry-run", action="store_true", help="Show what would be reset without changing anything")
    parser.add_argument("--reset-failed", action="store_true", help="Also reset FAILED items back to PENDING")
    args = parser.parse_args()

    backlog = Backlog(path=Path(args.backlog))

    # Find stuck items
    stuck = [e for e in backlog.entries.values() if e.status == BacklogStatus.IN_PROGRESS]
    failed = [e for e in backlog.entries.values() if e.status == BacklogStatus.FAILED] if args.reset_failed else []

    print(f"Current backlog state:")
    print(backlog.summary())
    print()

    if not stuck and not failed:
        print("No stuck items found.")
        return

    print(f"Found {len(stuck)} IN_PROGRESS items to reset:")
    for entry in stuck:
        print(f"  {entry.item.id} (attempts: {entry.attempts})")

    if failed:
        print(f"\nFound {len(failed)} FAILED items to reset:")
        for entry in failed:
            print(f"  {entry.item.id}: {entry.failure_reason or 'no reason'}")

    if args.dry_run:
        print("\n[DRY RUN] No changes made.")
        return

    # Reset stuck items to PENDING (refresh will move them to READY or BLOCKED)
    for entry in stuck:
        entry.status = BacklogStatus.PENDING

    for entry in failed:
        entry.status = BacklogStatus.PENDING
        entry.failure_reason = None

    # Refresh statuses (PENDING → READY or BLOCKED based on dependencies)
    backlog._refresh_statuses()
    backlog._save()

    print(f"\nReset {len(stuck)} IN_PROGRESS + {len(failed)} FAILED items.")
    print(f"\nNew backlog state:")
    print(backlog.summary())


if __name__ == "__main__":
    main()
```

**Acceptance criteria**:
- `python3 scripts/triage_backlog.py --dry-run` shows stuck items without modifying anything
- `python3 scripts/triage_backlog.py` resets IN_PROGRESS → PENDING, then refreshes (PENDING → READY or BLOCKED)
- `--reset-failed` also handles FAILED items
- Backlog is saved after triage
- No imports from leanknowledge that would trigger heavy model loading

**Constraints**:
- This is a standalone script, NOT a pipeline subcommand (to keep it separate from the main CLI)
- Don't modify backlog.py itself — just use its public API plus `_refresh_statuses()` and `_save()`

---

### TASK 5 — Citation Graph → Feeder Suggestions

**Goal**: Give the Feeder Agent access to the citation graph so it can suggest relevant economics papers as sources for blocked items. This is a lightweight "suggestions" integration — the Feeder gets a list of candidate papers that might contain the proof, but doesn't fetch or extract from them automatically.

**Files to create**:
- `src/leanknowledge/citation_suggestions.py` — loader + query interface for citation graph data

**Files to modify**:
- `src/leanknowledge/agents/feeder.py` — accept and use citation suggestions

**Files to read for context**:
- `citation_graph/build_graph.py` — understand the data format (papers.json, citations.json)
- `citation_graph/merge_graphs.py` — the merged graph format
- `src/leanknowledge/agents/feeder.py` — current Feeder implementation

**Data format** (from citation_graph/):
- `citation_graph/data/papers.json`: `{paper_id: {title, year, venue, authors: [...], abstract, ...}}`
- `citation_graph/data/citations.json`: `{paper_id: [cited_paper_id, ...]}`
- Papers are economics-focused (top journals: AER, Econometrica, JET, etc.)

**Implementation**:

1. Create `src/leanknowledge/citation_suggestions.py`:

```python
"""Citation graph suggestions for the Feeder Agent.

Loads the economics citation graph and provides keyword-based paper suggestions.
This is a lightweight search — no embeddings, just title/abstract keyword matching.
"""

import json
from dataclasses import dataclass
from pathlib import Path


@dataclass
class PaperSuggestion:
    """A suggested paper that might contain relevant proofs."""
    paper_id: str
    title: str
    year: int | None
    venue: str | None
    authors: list[str]
    abstract: str | None
    relevance_score: float  # 0-1, based on keyword overlap


CITATION_DATA_DIR = Path(__file__).resolve().parents[2] / "citation_graph" / "data"


class CitationSuggester:
    """Suggests relevant papers from the citation graph for blocked backlog items."""

    def __init__(self, data_dir: Path = CITATION_DATA_DIR):
        self.data_dir = data_dir
        self._papers: dict | None = None

    @property
    def papers(self) -> dict:
        if self._papers is None:
            self._papers = {}
            papers_file = self.data_dir / "papers.json"
            if papers_file.exists():
                self._papers = json.loads(papers_file.read_text(encoding="utf-8"))
        return self._papers

    def suggest(self, query: str, domain: str | None = None, top_k: int = 5) -> list[PaperSuggestion]:
        """Find papers whose title or abstract matches keywords from the query.

        Args:
            query: The theorem statement or description to find sources for.
            domain: Optional domain filter (e.g., "microeconomics", "game_theory").
            top_k: Number of suggestions to return.

        Returns:
            List of PaperSuggestion sorted by relevance_score descending.
        """
        if not self.papers:
            return []

        # Extract keywords from query (simple: split on whitespace, filter short words)
        keywords = set()
        for word in query.lower().split():
            # Strip punctuation
            clean = word.strip(".,;:()[]{}\"'")
            if len(clean) > 3 and clean not in _STOP_WORDS:
                keywords.add(clean)

        if not keywords:
            return []

        scored = []
        for paper_id, paper in self.papers.items():
            title = (paper.get("title") or "").lower()
            abstract = (paper.get("abstract") or "").lower()
            searchable = f"{title} {abstract}"

            # Count keyword matches
            matches = sum(1 for kw in keywords if kw in searchable)
            if matches == 0:
                continue

            score = matches / len(keywords)

            # Boost papers from relevant venues based on domain
            venue = paper.get("venue") or ""
            if domain and _venue_matches_domain(venue, domain):
                score *= 1.2  # 20% boost

            scored.append((score, paper_id, paper))

        scored.sort(key=lambda x: -x[0])

        suggestions = []
        for score, paper_id, paper in scored[:top_k]:
            suggestions.append(PaperSuggestion(
                paper_id=paper_id,
                title=paper.get("title", ""),
                year=paper.get("year"),
                venue=paper.get("venue"),
                authors=paper.get("authors", []),
                abstract=paper.get("abstract"),
                relevance_score=min(score, 1.0),
            ))

        return suggestions


def _venue_matches_domain(venue: str, domain: str) -> bool:
    """Check if a journal venue is relevant to the given domain."""
    venue_lower = venue.lower()
    domain_venues = {
        "microeconomics": ["econometrica", "american economic review", "journal of political economy",
                           "quarterly journal of economics", "review of economic studies"],
        "game_theory": ["games and economic behavior", "international journal of game theory",
                        "journal of economic theory", "theoretical economics"],
        "welfare_economics": ["social choice and welfare", "journal of public economics",
                              "american economic review"],
    }
    relevant = domain_venues.get(domain, [])
    return any(v in venue_lower for v in relevant)


_STOP_WORDS = {
    "the", "and", "for", "that", "this", "with", "from", "are", "was", "were",
    "been", "being", "have", "has", "had", "does", "did", "will", "would",
    "could", "should", "may", "might", "shall", "can", "each", "every",
    "some", "any", "all", "both", "such", "than", "then", "when", "where",
    "which", "while", "about", "above", "after", "before", "between", "into",
    "through", "during", "under", "over", "there", "here", "more", "most",
    "other", "only", "also", "very", "just", "because", "these", "those",
    "what", "show", "prove", "given", "holds", "true", "false", "proof",
}
```

2. Modify `src/leanknowledge/agents/feeder.py` — add citation suggestions to the LLM prompt context:

   In `FeederAgent.__init__()`, add an optional `citation_suggester` parameter:
   ```python
   def __init__(
       self,
       sources_dir: Path = Path("Sources"),
       call_fn=None,
       bib_index: BibIndex | None = None,
       citation_suggester=None
   ):
       self.sources_dir = sources_dir
       self.call_fn = call_fn or call_claude
       self.bib_index = bib_index or BibIndex()
       self.citation_suggester = citation_suggester
       self._sources_cache: list[str] | None = None
   ```

   In `_search_referenced()` and `_search_unreferenced()`, after the `bib_hints` section, add citation suggestions to the prompt:
   ```python
   # Citation graph suggestions
   citation_hints = []
   if self.citation_suggester:
       suggestions = self.citation_suggester.suggest(
           entry.item.statement, domain=entry.domain.value, top_k=3
       )
       citation_hints = [
           f"{s.title} ({s.year}, {s.venue}) — relevance: {s.relevance_score:.0%}"
           for s in suggestions
       ]
   ```

   Then append to the prompt:
   ```python
   if citation_hints:
       prompt += f"\nRelated papers from citation graph:\n" + "\n".join(citation_hints) + "\n"
   ```

3. In `pipeline.py`, pass the citation suggester when constructing the Feeder (inside `Pipeline.__init__` or `feed_blocked`):
   ```python
   from .citation_suggestions import CitationSuggester
   # In __init__:
   self.citation_suggester = CitationSuggester()
   self.feeder = FeederAgent(
       sources_dir=PROJECT_ROOT / "Sources",
       citation_suggester=self.citation_suggester,
   )
   ```

**Acceptance criteria**:
- `CitationSuggester` loads `citation_graph/data/papers.json` lazily
- `suggest("Nash equilibrium existence", domain="game_theory")` returns relevant papers
- Returns empty list gracefully when `citation_graph/data/` doesn't exist
- Feeder prompt now includes citation graph suggestions when available
- Existing tests still pass: `uv run pytest tests/`

**Constraints**:
- This is keyword-based search only — no embeddings, no LLM calls in the suggester
- Keep it lightweight — the suggester should load in <1s even with thousands of papers
- Don't modify the citation_graph/ scripts themselves
- The `citation_graph/data/` directory may not exist on all machines — handle gracefully

---

### TASK 6 — Lean REPL (Persistent Lean Process)

**Goal**: Replace cold-start `lake env lean` per compilation with a persistent Lean 4 process that keeps Mathlib loaded. This amortizes the ~30s Mathlib import across hundreds of queries, making the Verifier's 6-iteration repair loop dramatically faster.

**Files to create**:
- `src/leanknowledge/lean/repl.py` — persistent Lean REPL manager

**Files to modify**:
- `src/leanknowledge/lean/compiler.py` — use REPL when available, fall back to cold start

**Files to read for context**:
- `src/leanknowledge/lean/compiler.py` — current `LeanCompiler` implementation
- `src/leanknowledge/lean/errors.py` — `parse_compiler_output()` function
- `lakefile.toml` — project configuration

**Background**: Lean 4 supports a JSON-based REPL protocol. You can start a Lean process with `lake env lean --run Lean.Elab.Frontend --json` or use the `lean --worker` mode. However, the simplest approach that works with our Lake project is:

1. Start a subprocess with `lake repl` (Lean 4.x has `lake repl` which loads the Lake environment including Mathlib)
2. Send Lean code via stdin, read results from stdout/stderr

**Alternative (simpler) approach**: Use `lean --worker` mode which accepts JSON commands. But this requires more protocol handling.

**Recommended approach**: The simplest performant approach is to keep a warmed-up Lean environment by writing to a scratch file and compiling, but caching the `lake env` process environment. Actually, the most practical approach for our use case:

Use `lean --server` (LSP mode) via stdin/stdout with JSON-RPC to check code. But this is complex.

**Pragmatic approach**: Instead of a true REPL, implement a **warm compiler pool** — keep one `lake env lean` subprocess alive and reuse its environment:

```python
"""Persistent Lean compiler — avoids cold-starting Mathlib import on every compilation.

Uses a long-running `lake env lean` process approach:
- Writes code to a scratch file
- Sends SIGUSR1 or uses inotify to trigger recompilation
- Actually, simplest: just cache the env dict from `lake env printPaths` and use it
  to run `lean` directly (skipping `lake env` overhead each time).
"""

import json
import os
import subprocess
import tempfile
import time
from pathlib import Path
from typing import Optional

from .errors import parse_compiler_output
from ..schemas import CompilerError, LeanCode

ELAN_BIN = Path.home() / ".elan" / "bin"


class LeanREPL:
    """Persistent Lean environment that caches Lake's path configuration.

    On first use, runs `lake env printPaths --json` to get the Lean search paths,
    then uses `lean` directly with those paths for all subsequent compilations.
    This avoids the ~2-5s `lake env` overhead per compilation (Mathlib import
    time is still paid once per `lean` invocation, but the Lake resolution is cached).

    For true Mathlib-import amortization, we also support a "warm server" mode
    that keeps a Lean process with Mathlib pre-imported.
    """

    def __init__(self, project_dir: Path):
        self.project_dir = project_dir
        self._env_cache: dict[str, str] | None = None
        self._lean_path: str | None = None
        self._lean_src_path: str | None = None

    def _ensure_env(self):
        """Cache the Lake environment paths on first call."""
        if self._env_cache is not None:
            return

        env = os.environ.copy()
        env["PATH"] = f"{ELAN_BIN}:{env.get('PATH', '')}"

        # Get Lake's path configuration
        try:
            result = subprocess.run(
                ["lake", "env", "printPaths"],
                cwd=self.project_dir,
                capture_output=True,
                text=True,
                timeout=60,
                env=env,
            )
            if result.returncode == 0:
                # Parse the JSON output to get LEAN_PATH and LEAN_SRC_PATH
                paths_data = json.loads(result.stdout)
                self._lean_path = ":".join(paths_data.get("oleanPath", []))
                self._lean_src_path = ":".join(paths_data.get("srcPath", []))
        except (subprocess.TimeoutExpired, json.JSONDecodeError, FileNotFoundError):
            pass

        # Build cached environment
        self._env_cache = env.copy()
        if self._lean_path:
            self._env_cache["LEAN_PATH"] = self._lean_path
        if self._lean_src_path:
            self._env_cache["LEAN_SRC_PATH"] = self._lean_src_path

    def compile(self, lean_code: LeanCode) -> tuple[bool, list[CompilerError]]:
        """Compile Lean code using cached environment (skips lake env overhead)."""
        self._ensure_env()

        full_code = "\n".join(f"import {imp}" for imp in lean_code.imports)
        if lean_code.imports:
            full_code += "\n\n"
        full_code += lean_code.code

        # Write to scratch file in the project
        target = self.project_dir / "LeanKnowledge" / "Scratch.lean"
        target.parent.mkdir(parents=True, exist_ok=True)
        target.write_text(full_code)

        try:
            result = subprocess.run(
                ["lean", str(target)],
                cwd=self.project_dir,
                capture_output=True,
                text=True,
                timeout=300,
                env=self._env_cache,
            )

            if result.returncode == 0:
                return True, []

            errors = parse_compiler_output(result.stderr)
            return False, errors
        except subprocess.TimeoutExpired:
            return False, [CompilerError(message="Compilation timed out (300s)", category="unknown")]

    def invalidate_cache(self):
        """Force re-caching of Lake environment (e.g., after `lake update`)."""
        self._env_cache = None
        self._lean_path = None
        self._lean_src_path = None
```

Then modify `compiler.py` to optionally use the REPL:

```python
class LeanCompiler:
    def __init__(self, project_dir: Path | None = None, use_repl: bool = True):
        self.project_dir = project_dir
        self._repl: Optional["LeanREPL"] = None
        self._use_repl = use_repl

    @property
    def repl(self):
        if self._repl is None and self._use_repl and self.project_dir:
            from .repl import LeanREPL
            self._repl = LeanREPL(self.project_dir)
        return self._repl

    def compile(self, lean_code: LeanCode) -> tuple[bool, list[CompilerError]]:
        full_code = "\n".join(f"import {imp}" for imp in lean_code.imports)
        if lean_code.imports:
            full_code += "\n\n"
        full_code += lean_code.code

        if self.project_dir:
            # Try REPL first for speed, fall back to cold start
            if self.repl:
                try:
                    return self.repl.compile(lean_code)
                except Exception:
                    # Fall back to cold start if REPL fails
                    pass
            return self._compile_in_project(full_code)
        else:
            return self._compile_standalone(full_code)
```

**Acceptance criteria**:
- `LeanREPL` caches `lake env printPaths` output on first call
- Subsequent compilations use `lean` directly with cached env (skip `lake env` overhead)
- Falls back gracefully if `lake env printPaths` fails
- `invalidate_cache()` forces re-initialization
- `LeanCompiler` uses REPL by default when `project_dir` is set
- Existing tests still pass (compiler may be tested with `project_dir=None`, which skips REPL)

**Constraints**:
- This is a "warm environment" approach, NOT a true streaming REPL — each compilation still runs `lean` as a subprocess. The savings come from caching the Lake path resolution (~2-5s per call) and passing paths directly.
- True Mathlib import amortization (keeping Lean process alive with Mathlib loaded) would require LSP or a custom REPL protocol — that's a future enhancement. This task just eliminates the `lake env` overhead.
- Don't break the existing `_compile_in_project` or `_compile_standalone` methods — they're the fallback.
- The `LeanREPL` class should be in a separate file (`lean/repl.py`) to keep compiler.py clean.

---

### TASK 7 — SQLite Storage Migration

**Goal**: Replace the JSON-file-backed Backlog and Strategy KB with SQLite. This enables concurrent pipeline instances, faster queries on large datasets, and atomic writes.

**Files to create**:
- `src/leanknowledge/storage.py` — SQLite backend with `BacklogStore` and `StrategyStore`

**Files to modify**:
- `src/leanknowledge/backlog.py` — swap JSON persistence for SQLite
- `src/leanknowledge/strategy_kb.py` — swap JSON persistence for SQLite

**Files to read for context**:
- `src/leanknowledge/backlog.py` — current `_save()` and `_load()` methods
- `src/leanknowledge/strategy_kb.py` — current `save()` and `load()` methods
- `src/leanknowledge/schemas.py` — `BacklogEntry` and `StrategyEntry` data models

**Implementation**:

1. Create `src/leanknowledge/storage.py`:

```python
"""SQLite storage backend for Backlog and Strategy KB.

Migrates from JSON files while maintaining backward compatibility.
If a .json file exists but no .db file, auto-migrates on first access.
"""

import json
import sqlite3
from pathlib import Path
from contextlib import contextmanager
from dataclasses import asdict


DB_NAME = "leanknowledge.db"


@contextmanager
def _connect(db_path: Path):
    """Context manager for SQLite connections with WAL mode."""
    conn = sqlite3.connect(str(db_path))
    conn.execute("PRAGMA journal_mode=WAL")
    conn.execute("PRAGMA foreign_keys=ON")
    conn.row_factory = sqlite3.Row
    try:
        yield conn
        conn.commit()
    except Exception:
        conn.rollback()
        raise
    finally:
        conn.close()


def init_db(db_path: Path):
    """Create tables if they don't exist."""
    with _connect(db_path) as conn:
        conn.execute("""
            CREATE TABLE IF NOT EXISTS backlog (
                item_id TEXT PRIMARY KEY,
                data TEXT NOT NULL,  -- JSON blob of BacklogEntry
                status TEXT NOT NULL,
                domain TEXT NOT NULL,
                priority_score INTEGER DEFAULT 0,
                attempts INTEGER DEFAULT 0,
                added_at TEXT,
                completed_at TEXT
            )
        """)
        conn.execute("""
            CREATE INDEX IF NOT EXISTS idx_backlog_status ON backlog(status)
        """)
        conn.execute("""
            CREATE INDEX IF NOT EXISTS idx_backlog_domain ON backlog(domain)
        """)
        conn.execute("""
            CREATE TABLE IF NOT EXISTS strategy_kb (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                theorem_id TEXT NOT NULL,
                domain TEXT NOT NULL,
                data TEXT NOT NULL,  -- JSON blob of StrategyEntry
                difficulty TEXT,
                iterations INTEGER
            )
        """)
        conn.execute("""
            CREATE INDEX IF NOT EXISTS idx_strategy_domain ON strategy_kb(domain)
        """)
        conn.execute("""
            CREATE INDEX IF NOT EXISTS idx_strategy_theorem ON strategy_kb(theorem_id)
        """)


class BacklogStore:
    """SQLite-backed backlog storage."""

    def __init__(self, db_path: Path):
        self.db_path = db_path
        init_db(db_path)

    def save_all(self, entries: dict[str, "BacklogEntry"]):
        """Bulk save all entries (used for migration and full refreshes)."""
        with _connect(self.db_path) as conn:
            conn.execute("DELETE FROM backlog")
            for item_id, entry in entries.items():
                conn.execute(
                    "INSERT INTO backlog (item_id, data, status, domain, priority_score, attempts, added_at, completed_at) VALUES (?, ?, ?, ?, ?, ?, ?, ?)",
                    (item_id, entry.model_dump_json(), entry.status.value, entry.domain.value,
                     entry.priority_score, entry.attempts,
                     entry.added_at.isoformat() if entry.added_at else None,
                     entry.completed_at.isoformat() if entry.completed_at else None)
                )

    def load_all(self) -> dict[str, "BacklogEntry"]:
        """Load all entries."""
        from .schemas import BacklogEntry
        entries = {}
        with _connect(self.db_path) as conn:
            for row in conn.execute("SELECT item_id, data FROM backlog"):
                entries[row["item_id"]] = BacklogEntry.model_validate_json(row["data"])
        return entries

    def upsert(self, item_id: str, entry: "BacklogEntry"):
        """Insert or update a single entry."""
        with _connect(self.db_path) as conn:
            conn.execute(
                """INSERT OR REPLACE INTO backlog
                   (item_id, data, status, domain, priority_score, attempts, added_at, completed_at)
                   VALUES (?, ?, ?, ?, ?, ?, ?, ?)""",
                (item_id, entry.model_dump_json(), entry.status.value, entry.domain.value,
                 entry.priority_score, entry.attempts,
                 entry.added_at.isoformat() if entry.added_at else None,
                 entry.completed_at.isoformat() if entry.completed_at else None)
            )

    def count_by_status(self) -> dict[str, int]:
        """Fast status counts without loading all entries."""
        with _connect(self.db_path) as conn:
            counts = {}
            for row in conn.execute("SELECT status, COUNT(*) as cnt FROM backlog GROUP BY status"):
                counts[row["status"]] = row["cnt"]
            return counts


class StrategyStore:
    """SQLite-backed strategy KB storage."""

    def __init__(self, db_path: Path):
        self.db_path = db_path
        init_db(db_path)

    def save_all(self, entries: list):
        """Bulk save all entries (used for migration)."""
        with _connect(self.db_path) as conn:
            conn.execute("DELETE FROM strategy_kb")
            for entry in entries:
                data = json.dumps(asdict(entry), separators=(",", ":"))
                conn.execute(
                    "INSERT INTO strategy_kb (theorem_id, domain, data, difficulty, iterations) VALUES (?, ?, ?, ?, ?)",
                    (entry.theorem_id, entry.domain, data, entry.difficulty, entry.iterations_to_compile)
                )

    def load_all(self) -> list:
        """Load all entries."""
        from .strategy_kb import StrategyEntry
        entries = []
        with _connect(self.db_path) as conn:
            for row in conn.execute("SELECT data FROM strategy_kb"):
                entries.append(StrategyEntry(**json.loads(row["data"])))
        return entries

    def add(self, entry) -> None:
        """Add a single entry."""
        data = json.dumps(asdict(entry), separators=(",", ":"))
        with _connect(self.db_path) as conn:
            conn.execute(
                "INSERT INTO strategy_kb (theorem_id, domain, data, difficulty, iterations) VALUES (?, ?, ?, ?, ?)",
                (entry.theorem_id, entry.domain, data, entry.difficulty, entry.iterations_to_compile)
            )

    def query_by_domain(self, domain: str) -> list:
        """Fast domain-filtered query."""
        from .strategy_kb import StrategyEntry
        entries = []
        with _connect(self.db_path) as conn:
            for row in conn.execute("SELECT data FROM strategy_kb WHERE domain = ?", (domain,)):
                entries.append(StrategyEntry(**json.loads(row["data"])))
        return entries


def migrate_json_to_sqlite(
    backlog_json: Path | None = None,
    strategy_json: Path | None = None,
    db_path: Path | None = None,
):
    """One-time migration from JSON files to SQLite.

    Usage:
        python -m leanknowledge.storage  # auto-detects files in project root
    """
    from .schemas import BacklogEntry
    from .strategy_kb import StrategyEntry

    project_root = Path(__file__).resolve().parents[2]
    db_path = db_path or (project_root / DB_NAME)

    init_db(db_path)

    # Migrate backlog
    bl_path = backlog_json or (project_root / "backlog.json")
    if bl_path.exists():
        print(f"Migrating backlog from {bl_path}...")
        raw = json.loads(bl_path.read_text())
        entries = {k: BacklogEntry.model_validate(v) for k, v in raw.items()}
        store = BacklogStore(db_path)
        store.save_all(entries)
        print(f"  Migrated {len(entries)} backlog entries.")

    # Migrate strategy KB
    sk_path = strategy_json or (project_root / "strategy_kb.json")
    if sk_path.exists():
        print(f"Migrating strategy KB from {sk_path}...")
        raw = json.loads(sk_path.read_text())
        kb_entries = [StrategyEntry(**item) for item in raw]
        store = StrategyStore(db_path)
        store.save_all(kb_entries)
        print(f"  Migrated {len(kb_entries)} strategy entries.")

    print(f"Migration complete: {db_path}")


if __name__ == "__main__":
    migrate_json_to_sqlite()
```

2. Modify `backlog.py` — add SQLite support alongside JSON:

   In `Backlog.__init__()`, detect whether to use SQLite:
   ```python
   def __init__(self, path: Path = DEFAULT_PATH):
       self.path = path
       self.entries: dict[str, BacklogEntry] = {}

       # Check for SQLite database
       self._db_path = path.parent / "leanknowledge.db"
       self._use_sqlite = self._db_path.exists()

       if self._use_sqlite:
           from .storage import BacklogStore
           self._store = BacklogStore(self._db_path)
           self.entries = self._store.load_all()
       elif self.path.exists():
           self._load()
   ```

   In `_save()`, save to both JSON and SQLite (if SQLite is active):
   ```python
   def _save(self):
       # Always save JSON (backward compatibility)
       data = {item_id: entry.model_dump(mode="json") for item_id, entry in self.entries.items()}
       self.path.write_text(json.dumps(data, indent=2, default=str))

       # Also save to SQLite if active
       if self._use_sqlite:
           self._store.save_all(self.entries)
   ```

3. Modify `strategy_kb.py` — add SQLite support alongside JSON:

   In `StrategyKB.__init__()`:
   ```python
   def __init__(self, path: Path = Path("strategy_kb.json")):
       self.path = path
       self._entries: list[StrategyEntry] | None = None

       # Check for SQLite database
       self._db_path = path.parent / "leanknowledge.db"
       self._use_sqlite = self._db_path.exists()
       if self._use_sqlite:
           from .storage import StrategyStore
           self._store = StrategyStore(self._db_path)
   ```

   In `save()`:
   ```python
   def save(self) -> None:
       # Always save JSON (backward compat)
       data = [asdict(e) for e in self.entries]
       self.path.write_text(json.dumps(data, separators=(",", ":")), encoding="utf-8")

       # Also save to SQLite if active
       if self._use_sqlite:
           self._store.save_all(self.entries)
   ```

4. Add a CLI migration command to `pipeline.py`:
   ```python
   # Migrate: JSON → SQLite
   migrate_parser = subparsers.add_parser("migrate", help="Migrate JSON files to SQLite")
   add_common_args(migrate_parser)
   ```
   And:
   ```python
   elif args.command == "migrate":
       from .storage import migrate_json_to_sqlite
       migrate_json_to_sqlite()
   ```

**Acceptance criteria**:
- `python -m leanknowledge.storage` migrates backlog.json + strategy_kb.json → leanknowledge.db
- `leanknowledge migrate` does the same via CLI
- After migration, Backlog and StrategyKB read from SQLite
- JSON files are still written as backup (dual-write)
- If no .db file exists, behavior is identical to before (JSON-only)
- Existing tests still pass: `uv run pytest tests/`

**Constraints**:
- Use Python's built-in `sqlite3` — no external dependency
- WAL journal mode for concurrent read access
- Keep JSON as primary format if .db doesn't exist (backward compatible)
- The migration is opt-in: run `leanknowledge migrate` to create the .db, then it auto-detects
- Don't remove JSON reading/writing — keep dual-write until we're confident SQLite is stable
- The 221K-entry strategy_kb.json is ~221MB — SQLite migration may take a few seconds. That's fine.

**Tests to add** (`tests/test_storage.py`):
```python
import pytest
from pathlib import Path
from leanknowledge.storage import BacklogStore, StrategyStore, init_db
from leanknowledge.schemas import BacklogEntry, ExtractedItem, StatementType, ClaimRole, Domain, BacklogStatus
from leanknowledge.strategy_kb import StrategyEntry

@pytest.fixture
def db_path(tmp_path):
    return tmp_path / "test.db"

def test_backlog_store_roundtrip(db_path):
    store = BacklogStore(db_path)
    item = ExtractedItem(id="test_1", type=StatementType.THEOREM, statement="x > 0", section="1.A")
    entry = BacklogEntry(item=item, source="test", domain=Domain.REAL_ANALYSIS)
    store.upsert("test_1", entry)
    loaded = store.load_all()
    assert "test_1" in loaded
    assert loaded["test_1"].item.statement == "x > 0"

def test_strategy_store_roundtrip(db_path):
    store = StrategyStore(db_path)
    entry = StrategyEntry(
        theorem_id="thm1", domain="real_analysis", mathematical_objects=["set"],
        proof_strategies=["direct"], lean_tactics_used=["intro"], lean_tactics_failed=[],
        difficulty="easy", iterations_to_compile=1, proof_revisions=0,
        error_types_encountered=[], dependencies_used=[], source="test"
    )
    store.add(entry)
    loaded = store.load_all()
    assert len(loaded) == 1
    assert loaded[0].theorem_id == "thm1"

def test_count_by_status(db_path):
    store = BacklogStore(db_path)
    item1 = ExtractedItem(id="t1", type=StatementType.THEOREM, statement="a", section="1")
    item2 = ExtractedItem(id="t2", type=StatementType.THEOREM, statement="b", section="1")
    store.upsert("t1", BacklogEntry(item=item1, source="s", domain=Domain.ALGEBRA, status=BacklogStatus.READY))
    store.upsert("t2", BacklogEntry(item=item2, source="s", domain=Domain.ALGEBRA, status=BacklogStatus.COMPLETED))
    counts = store.count_by_status()
    assert counts["ready"] == 1
    assert counts["completed"] == 1
```

---

### TASK 8 — LiteLLM Gateway

**Goal**: Replace direct Anthropic SDK calls with a LiteLLM-based gateway that provides a unified OpenAI-compatible interface across providers (Anthropic, OpenAI, local vLLM, DeepSeek). This enables provider flexibility and simplifies adding new backends.

**Files to create**:
- `src/leanknowledge/llm_gateway.py` — unified LLM gateway using litellm

**Files to modify**:
- `pyproject.toml` — add `litellm` dependency
- `src/leanknowledge/claude_client.py` — add gateway mode alongside existing SDK mode

**Files to read for context**:
- `src/leanknowledge/claude_client.py` — current `call_claude()` implementation
- `src/leanknowledge/deepseek_client.py` — current `call_deepseek()` implementation

**Implementation**:

1. Add `litellm>=1.0` to `pyproject.toml` dependencies.

2. Create `src/leanknowledge/llm_gateway.py`:

```python
"""Unified LLM gateway using LiteLLM.

Provides a single `call_llm()` function that routes to any supported provider:
- Anthropic (Claude): "claude-sonnet-4-6", "claude-haiku-4-5-20251001"
- OpenAI: "gpt-4o", "gpt-4o-mini"
- DeepSeek: "deepseek/deepseek-prover-v2"
- Local vLLM: "openai/my-model" (with api_base override)

Usage:
    from leanknowledge.llm_gateway import call_llm
    result = call_llm("Prove this theorem", system="You are a proof assistant", model="claude-sonnet-4-6")
"""

import json
import logging
import os
import re
from pydantic import BaseModel

try:
    import litellm
    litellm.drop_params = True  # Don't error on unsupported params
    HAS_LITELLM = True
except ImportError:
    HAS_LITELLM = False

from .claude_client import usage_tracker, _CallRecord

log = logging.getLogger(__name__)

# Model aliases for convenience
MODEL_ALIASES = {
    "sonnet": "claude-sonnet-4-6",
    "haiku": "claude-haiku-4-5-20251001",
    "opus": "claude-opus-4-6",
    "deepseek": "deepseek/deepseek-prover-v2-7b",
    "gpt4o": "openai/gpt-4o",
}

DEFAULT_MODEL = "claude-sonnet-4-6"


def call_llm(
    prompt: str,
    system: str = "",
    schema: type[BaseModel] | None = None,
    model: str | None = None,
    caller: str = "",
    api_base: str | None = None,
    temperature: float | None = None,
    max_tokens: int = 4096,
) -> str | dict:
    """Call any LLM provider through LiteLLM.

    Args:
        prompt: User message.
        system: System prompt.
        schema: If provided, request JSON conforming to this Pydantic model.
        model: Model name (supports aliases). Defaults to claude-sonnet-4-6.
        caller: Label for usage tracking.
        api_base: Optional API base URL (for local vLLM).
        temperature: Optional sampling temperature.
        max_tokens: Max output tokens.

    Returns:
        Raw text response, or parsed dict if schema is provided.
    """
    if not HAS_LITELLM:
        raise ImportError("litellm is required. Install with: uv add litellm")

    # Unset CLAUDECODE to prevent interference in Claude Code sessions
    os.environ.pop("CLAUDECODE", None)

    # Resolve aliases
    resolved_model = MODEL_ALIASES.get(model or "", model or DEFAULT_MODEL)

    messages = []
    if system:
        messages.append({"role": "system", "content": system})
    messages.append({"role": "user", "content": prompt})

    kwargs = {
        "model": resolved_model,
        "messages": messages,
        "max_tokens": max_tokens,
    }

    if temperature is not None:
        kwargs["temperature"] = temperature

    if api_base:
        kwargs["api_base"] = api_base

    if schema:
        # Request JSON response
        kwargs["response_format"] = {"type": "json_object"}
        # Add schema hint to prompt
        schema_json = json.dumps(schema.model_json_schema(), indent=2)
        messages[-1]["content"] += f"\n\nRespond with JSON matching this schema:\n```json\n{schema_json}\n```"

    try:
        response = litellm.completion(**kwargs)
    except Exception as e:
        raise RuntimeError(f"LLM call failed ({resolved_model}): {e}")

    text = response.choices[0].message.content or ""

    # Track usage
    usage = response.usage
    if usage:
        rec = _CallRecord(
            caller=caller,
            model=resolved_model,
            input_tokens=usage.prompt_tokens or 0,
            output_tokens=usage.completion_tokens or 0,
        )
        usage_tracker.record(rec)
        log.debug("call_llm [%s] model=%s in=%d out=%d", caller, resolved_model, rec.input_tokens, rec.output_tokens)

    if schema is None:
        return text

    # Parse JSON
    try:
        return json.loads(text)
    except json.JSONDecodeError:
        return _extract_json(text)


def _extract_json(text: str) -> dict:
    """Extract JSON from text that may contain markdown fences."""
    match = re.search(r"```(?:json)?\s*\n?(.*?)\n?\s*```", text, re.DOTALL)
    if match:
        try:
            return json.loads(match.group(1))
        except json.JSONDecodeError:
            pass

    for start_char, end_char in [("{", "}"), ("[", "]")]:
        start = text.find(start_char)
        if start != -1:
            depth = 0
            for i, c in enumerate(text[start:], start):
                if c == start_char:
                    depth += 1
                elif c == end_char:
                    depth -= 1
                    if depth == 0:
                        try:
                            return json.loads(text[start:i + 1])
                        except json.JSONDecodeError:
                            break

    raise ValueError(f"Could not extract JSON from response:\n{text[:500]}")
```

3. Add a gateway mode to `claude_client.py` — at the top, add:
   ```python
   # Check if gateway mode is enabled
   USE_GATEWAY = os.environ.get("LK_USE_GATEWAY", "").lower() in ("1", "true", "yes")
   ```

   Then at the very start of `call_claude()`:
   ```python
   if USE_GATEWAY:
       from .llm_gateway import call_llm
       return call_llm(prompt, system=system, schema=schema, model=model, caller=caller)
   ```

   This means:
   - By default, nothing changes — `call_claude()` uses the Anthropic SDK directly
   - Set `LK_USE_GATEWAY=1` to route through LiteLLM instead
   - This is a non-breaking, opt-in change

4. Update `deepseek_client.py` to also support gateway mode:
   At the start of `call_deepseek()`:
   ```python
   if os.environ.get("LK_USE_GATEWAY", "").lower() in ("1", "true", "yes"):
       from .llm_gateway import call_llm
       return call_llm(prompt, system=system, schema=schema, model="deepseek", caller=caller)
   ```

**Acceptance criteria**:
- `call_llm("Hello", model="sonnet")` works and returns text
- `call_llm("Hello", model="deepseek")` routes to DeepSeek
- `LK_USE_GATEWAY=1 leanknowledge next` uses LiteLLM instead of direct Anthropic SDK
- Without `LK_USE_GATEWAY`, behavior is 100% identical to before
- Usage tracking works through the gateway
- Schema extraction works through the gateway
- Existing tests still pass: `uv run pytest tests/`

**Constraints**:
- LiteLLM is an **optional** dependency — if not installed, `call_llm()` raises ImportError
- Gateway mode is opt-in via `LK_USE_GATEWAY=1` environment variable
- Don't remove or modify the existing `call_claude()` Anthropic SDK path — it's the battle-tested default
- Don't remove `deepseek_client.py` — just add gateway support as an alternative
- The `response_format` parameter works differently in LiteLLM vs Anthropic SDK — use `{"type": "json_object"}` with schema in prompt for LiteLLM, since native `json_schema` may not be supported across all providers

---

## Training Tasks (Server — Tonight)

These are NOT Gemini tasks. These are manual steps to run on the EML server.

### TRAINING 1 — Prepare Data Splits

```bash
# SSH into server, navigate to project
cd /path/to/LeanKnowledge

# Prepare train/val/test splits from Rosetta Stone corpus
python training/prepare_data.py \
    --pairs_dir rosetta_stone/pairs \
    --pipeline_data_dir training_data \
    --output_dir training/data \
    --seed 42
```

Expected output: `training/data/{train,val,test}.json` with ~200K/11K/11K entries.

### TRAINING 2 — Submit QLoRA Training Job

```bash
# Review and adjust SLURM script if needed
# Key params: --epochs 3, --batch_size 4, --grad_accum 8, --lora_rank 64
sbatch training/slurm_train.sh
```

Monitor with `squeue -u $USER` and `tail -f training/adapters/translator_v0/training.log`.

### TRAINING 3 — Evaluate Trained Adapter

After training completes:
```bash
sbatch training/slurm_eval.sh
```

This runs `eval_translator.py` which:
1. Loads the trained adapter
2. Generates Lean translations for test set
3. Compiles each with `lake env lean`
4. Reports Pass@1 and Pass@k metrics

---

## Task Order and Dependencies

```
TASK 1 (Feeder Integration)  ──→  TASK 5 (Citation → Feeder)
TASK 2 (Strategy KB → Translator)  [independent]
TASK 3 (CLAUDECODE fix)  [independent, trivial]
TASK 4 (Triage script)  [independent, trivial]
TASK 6 (Lean REPL)  [independent]
TASK 7 (SQLite)  [independent]
TASK 8 (LiteLLM)  [independent]
```

**Recommended execution order**:
1. Tasks 3, 4 (trivial, 5 min each)
2. Task 1 (Feeder integration — highest impact)
3. Task 2 (Strategy KB → Translator)
4. Task 5 (Citation → Feeder — depends on Task 1)
5. Tasks 6, 7, 8 (infrastructure — can be done in any order)

---

## Architecture After Phase 2

```
PDF/Text ──→ Extraction Agent ──→ Router ──→ Backlog (SQLite-backed)
                                                 │
                    ┌────────────────────────────┤
                    ▼                            ▼
              Feeder Agent                 Formalization Pipeline
              (BibIndex + CitationGraph)   ├─ Stage 1: Proof Agent (+ Strategy KB hints)
              ↓ finds source → extract     ├─ Stage 2: Translator (+ KB tactic hints)
              ↓ unblocks dependents        ├─ Stage 3: Verifier (Lean REPL + RepairDB)
                                           └─ Stage 4: Knowledge Agent (+ KB write)
                                                 │
                    ┌────────────────────────────┤
                    ▼                            ▼
              Training Data              Verified Lean Code
              (NL-Lean pairs)            (outputs/*.lean)
                    │
                    ▼
              QLoRA Fine-tuning ──→ Eval ──→ RL Repair (Phase 3)
              (DeepSeek-Prover)

LLM calls: call_claude() ──[opt-in]──→ LiteLLM gateway ──→ Any provider
Storage:   JSON (default) ──[opt-in]──→ SQLite (after `leanknowledge migrate`)
Compiler:  lake env lean  ──[auto]───→ Lean REPL (cached paths)
```
