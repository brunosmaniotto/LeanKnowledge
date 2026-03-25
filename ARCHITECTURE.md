# LeanKnowledge — Architecture

## 1. What This System Does

LeanKnowledge is a multi-agent pipeline that reads economics papers and textbooks, extracts mathematical claims, and produces machine-verified formal proofs in Lean 4. The primary target is **microeconomic theory** — a field that is entirely absent from Mathlib despite having a rigorous, proof-based literature spanning ~80 years and ~364,000 well-cited papers.

The core thesis: **formalizing known mathematics is a translation problem, and LLMs are good at translation.** Rather than chasing novel proofs, we systematically convert the canonical results of microeconomic theory into machine-verified code.

### Why microeconomics?

1. **Not in Mathlib.** Every formalization is genuinely new — no risk of duplicating existing work.
2. **Self-contained.** Draws on optimization, fixed-point theorems, and basic analysis. No deep dependency chains into, e.g., algebraic geometry.
3. **Young field.** Begins with von Neumann & Morgenstern (1944). The entire canonical literature fits within ~80 years.
4. **Uniform proof patterns.** Constrained optimization, envelope theorems, fixed-point existence, comparative statics — repetitive structure plays to LLM strengths.
5. **Mappable.** The OpenAlex citation graph (364K papers, 2.7M edges) gives us a complete, quantifiable picture of the field.

---

## 2. Agent 1 — Extraction

**Role:** Read a PDF (or text) source and extract every mathematical claim as a structured object.

**Two-tier text extraction with automatic escalation:**

```
PDF input
    │
    ▼
┌─────────────────────┐
│  Tier 1: PyMuPDF    │  Free, fast, local.
│  (text extraction)  │  Works well on born-digital PDFs.
└─────────┬───────────┘
          │
    ┌─────▼──────┐
    │ Quality    │  Checks: text density, unicode garbage,
    │ Gate       │  page coverage (% of pages with text)
    └─────┬──────┘
          │
     ok?──┤
     │    │
     │    no
     │    │
     │    ▼
     │  ┌─────────────────────┐
     │  │ Tier 2: Google      │  Handles scans, complex layouts,
     │  │ Document AI         │  degraded math symbols.
     │  └─────────┬───────────┘
     │            │
     ▼            ▼
┌────────────────────────────┐
│  LLM Claim Extraction      │  Reads extracted text,
│  (Anthropic API)           │  produces structured claims.
└────────────────────────────┘
```

### Quality gate signals (Tier 1 → Tier 2)

| Signal | Threshold | Rationale |
|--------|-----------|-----------|
| Page coverage | < 70% of pages have text | Scanned PDF — most pages are images |
| Text density | < 100 chars/page average | Too little text extracted |
| Garbage ratio | > 3% replacement/control chars | Broken unicode, failed math symbols |

### Why not LLM vision as Tier 2?

LLM vision (sending page images to Claude) is expensive per page and not purpose-built for OCR. Google Document AI is specifically designed for document parsing — it handles scans, tables, and mathematical notation more reliably and cost-effectively. LLM vision is better used downstream (interpreting figures, disambiguating notation) than for raw text extraction.

### Output

Each extracted claim is a structured object:

```
ExtractedItem:
  id: str              # "Proposition 3.D.2" or "Claim 1.B.a" for unlabeled
  type: StatementType  # definition, theorem, lemma, claim, ...
  role: ClaimRole      # definition, claimed_result, invoked_dependency, ...
  statement: str       # precise mathematical statement
  proof: str | None    # full proof if present
  proof_sketch: str | None
  dependencies: list[str]
  section: str
  labeled: bool        # False if extracted from prose
  context: str | None  # surrounding text for disambiguation
  notation_in_scope: dict[str, str]
```

The agent extracts both formally labeled items ("Theorem 2.1") and claims embedded in prose ("Note that completeness implies reflexivity"). The latter is harder and more important — textbooks contain enormous mathematical content that is never formally labeled.

### Key files

- `src/leanknowledge/agents/extraction.py` — Agent 1 implementation
- `src/leanknowledge/pdf_quality.py` — Quality gate logic

---

## 3. Agent 2 — Claim Extraction

**Role:** Read mathematical text (from Agent 1) and extract every mathematical claim as a structured object.

**Ensemble approach with escalation:**

```
Text from Agent 1
        │
        ├──────────────────┐
        ▼                  ▼
┌──────────────┐  ┌──────────────┐
│   Sonnet     │  │  DeepThink   │    Run in parallel.
│  (Claude)    │  │  (DeepSeek)  │    Different families = different blind spots.
└──────┬───────┘  └──────┬───────┘
       │                 │
       ▼                 ▼
    ┌────────────────────────┐
    │  Programmatic          │    Compare: item count, statement overlap.
    │  Agreement Check       │    No LLM call — just fuzzy string matching.
    └───────────┬────────────┘
                │
         agree? ┤
           │    │
           │    no → disagreement
           │    │
           │    ▼
           │  ┌──────────────────────┐
           │  │  Opus (arbiter)      │  Sees BOTH extractions + source text.
           │  │  Reconciles diffs.   │  Doesn't re-extract blindly.
           │  └──────────┬───────────┘
           │             │
           ▼             ▼
    ┌─────────────────────────┐
    │  Merged ExtractionResult │
    └─────────────────────────┘
```

### Why mix model families?

Models from the same family share **correlated blind spots**. If DeepSeek struggles with a particular notation convention, running two copies of DeepSeek both miss it. Different architectures (Anthropic vs DeepSeek) are trained on different data and have different failure modes — making disagreement a far more meaningful signal than any heuristic quality check.

### Disagreement signals (programmatic, no LLM)

| Signal | Threshold | Meaning |
|--------|-----------|---------|
| Count divergence | > 40% difference | One model found significantly more claims |
| Overlap A in B | < 60% matched | Many of A's claims have no counterpart in B |
| Overlap B in A | < 60% matched | Many of B's claims have no counterpart in A |

Matching uses fuzzy string similarity on claim statements. Two statements are considered "the same" if similarity > 0.6.

### The arbiter (Opus)

When escalated, Opus does NOT re-extract from scratch. It receives:
1. Model A's full extraction
2. Model B's full extraction
3. The original source text
4. The disagreement reason

Its job is to *reconcile* — check each disagreement against the source and produce the definitive result. This is much cheaper than running Opus on every input.

### Model defaults and routing

All LLM calls go through `llm.py`, which supports three backends:

| Model prefix | Backend | Cost |
|-------------|---------|------|
| `anthropic/`, `deepseek/`, `openai/`, `gemini/` | LiteLLM API | Per-call API credits |
| `cli/claude` or `cli/claude/<model>` | Claude Code CLI (subprocess) | Max/Pro subscription |
| `cli/gemini` or `cli/gemini/<model>` | Gemini CLI (subprocess) | Google account |

Default env vars:

| Role | Env var | Default |
|------|---------|---------|
| Fast model A | `LK_MODEL_FAST_A` | `anthropic/claude-sonnet-4-20250514` |
| Fast model B | `LK_MODEL_FAST_B` | `deepseek/deepseek-reasoner` |
| Heavy model | `LK_MODEL_HEAVY` | `anthropic/claude-sonnet-4-20250514` |

Swap providers by changing env vars. Examples:
- `LK_MODEL_HEAVY=cli/claude` — use Claude Code subscription instead of API credits
- `LK_MODEL_HEAVY=gemini/gemini-2.5-pro` — use Gemini via LiteLLM (GCP credits)
- `LK_MODEL_HEAVY=cli/gemini/gemini-2.5-pro` — use Gemini CLI subscription

### Key files

- `src/leanknowledge/agents/extraction.py` — Agent 1 (PDF → text)
- `src/leanknowledge/agents/claim_extraction.py` — Agent 2 (text → claims)
- `src/leanknowledge/llm.py` — LiteLLM gateway
- `src/leanknowledge/pdf_quality.py` — Agent 1 quality gate
- `prompts/extraction_agent.md` — LLM system prompt (shared by both ensemble models + arbiter)
- `src/leanknowledge/schemas.py` — Data contracts (ExtractedItem, ExtractionResult)

---

## 4. Agent 3 — Triage

**Role:** Classify each extracted claim as **definition** or **theorem**, then place it in the inbox (staging area for the backlog).

**Key design decision:** Definitions are formalized just like theorems. In Lean 4, a `def`, `structure`, `class`, or `instance` must typecheck — it's real work, not just a label. The category tag travels with the item through the entire pipeline.

**Axioms are treated as definitions.** What textbooks call "axioms" are usually definitional properties of the structure being studied (e.g., "preferences are complete and transitive" defines rational preferences). Truly foundational axioms (ZFC, etc.) are also definitions of the formal framework.

### Classification (deterministic, no LLM)

| ExtractedItem type | → Category | Rationale |
|---|---|---|
| definition | DEFINITION | Explicit |
| axiom | DEFINITION | Defines the structure |
| implicit_assumption | DEFINITION | Unstated framework assumption |
| theorem, proposition, lemma, corollary, claim | THEOREM | Needs proof |
| example, remark, invoked_dependency | By role field | Ambiguous types: if role = "definition" → DEFINITION, else → THEOREM |

This is fully deterministic — no LLM call, just type/role mapping.

### Inbox → Backlog

The inbox is a staging area. Items flow through it into the backlog carrying their category label:

```
Agent 2 output (ExtractionResult)
        │
        ▼
┌──────────────────┐
│  Agent 3: Triage │   Classify each item: DEFINITION or THEOREM
└────────┬─────────┘
         ▼
┌──────────────────┐
│     Inbox        │   Staging area, classified items
└────────┬─────────┘
         ▼
┌──────────────────┐
│     Backlog      │   Work queue (auto-resolves deps)
└──────────────────┘
```

### Dependency philosophy

Items are **never blocked** by unresolved dependencies. Every item enters the backlog as READY immediately. When the prover encounters an unproven dependency at proof time, it axiomatizes it (stubs it as a Lean axiom) and adds it to the backlog — no recursive proving, no blocking.

Dependencies are tracked for informational purposes (`unresolved_deps`) and ordering hints, but they do not gate formalization. This avoids cascading blockages where a single failed theorem freezes all its dependents.

### Key files

- `src/leanknowledge/agents/triage.py` — Agent 3 implementation + Inbox/InboxItem schemas

---

## 5. Agent 4 — Librarian

**Role:** Deduplication gate between inbox and backlog. Checks every item (definitions AND theorems) against existing formalized content before it enters the work queue.

```
Inbox (from Agent 3)
    │
    ▼
┌───────────────────────┐
│  Agent 4: Librarian   │   Check each item against:
│                       │     1. Knowledge tree (our formalized items)
│                       │     2. Mathlib (via Rosetta Stone)
└───────────┬───────────┘
            │
     ┌──────┴──────┐
     │             │
  EXACT         PARTIAL / NONE
  MATCH         MATCH
     │             │
     ▼             ▼
   SKIP          Backlog
  (link to       (new work)
  existing)
```

### Match types

| Match | Similarity | Action |
|-------|-----------|--------|
| EXACT | ≥ 90% | Skip — record the link (e.g., "Prop 3.D.2 = `Mathlib.Order.Complete.refl`") |
| PARTIAL | 50-90% | Backlog — related item exists but not identical (e.g., special case, converse) |
| NONE | < 50% | Backlog — nothing found |

Partial matches go to the backlog, not to human review. The matched item's name is recorded in the verdict for downstream use (the prover can reference it).

### Matching: current vs production

**Current:** Name matching + text similarity (SequenceMatcher). Simple, fast, good enough for exact duplicates.

**Planned enhancement (not yet implemented): three-layer semantic search.**

The `Library` interface is designed for swappable backends. `InMemoryLibrary` for testing; the production stack layers three backends with increasing cost:

```
Query: "Every closed subset of a compact set is compact"
         │
         ▼
┌──────────────────────────┐
│  Layer 1: Embedding      │  Sentence-transformer (all-MiniLM-L6-v2, ~80MB)
│  search over Rosetta     │  over 222K NL-Lean pairs.
│  Stone corpus            │  Cosine similarity, ~5ms/query.
└──────────┬───────────────┘
           │
     score ≥ 0.85 → auto-match (skip LLM)
     score ≥ 0.70 → borderline (verify with LLM)
     score < 0.70 ↓
           │
           ▼
┌──────────────────────────┐
│  Layer 2: Loogle         │  Type-based search over Mathlib.
│  (loogle.lean-lang.org)  │  Free API, searches by type signature.
│                          │  Catches results that differ in wording
│                          │  but match structurally.
└──────────┬───────────────┘
           │
     hit? → use Loogle name + module as match
     no hit ↓
           │
           ▼
┌──────────────────────────┐
│  Layer 3: LLM fallback   │  Send the statement + top-N near-misses
│  (Haiku, cheap)          │  from Layers 1-2 to a fast LLM for
│                          │  semantic judgment.
└──────────────────────────┘
```

**Why this stack?**

- **Embeddings** catch meaning-preserving rephrasings ("bounded and closed" ≈ "compact in ℝⁿ") that text similarity misses. The Rosetta Stone corpus gives us a domain-specific embedding space — general-purpose embeddings struggle with math notation.
- **Loogle** catches structural matches that embeddings miss. A statement about continuous functions on compact sets will have a specific type signature in Lean — Loogle can find the Mathlib theorem directly from that signature, even if the English phrasing is completely different.
- **LLM fallback** handles the long tail of genuinely ambiguous cases. Most queries should be resolved by Layers 1-2 without any LLM cost.

**Implementation plan:**

1. Build embedding index from the Rosetta Stone corpus (one-time batch job, ~30 min)
2. Implement `EmbeddingLibrary(Library)` backend with threshold-based routing
3. Implement `LoogleLibrary(Library)` backend wrapping the Loogle API
4. Implement `StackedLibrary(Library)` that chains them: embedding → Loogle → LLM
5. Wire into the pipeline as the default `Library` when embeddings are available

The `InMemoryLibrary` stays as the test backend. The stacked library is an incremental upgrade — each layer can be added independently.

### Key files

- `src/leanknowledge/agents/librarian.py` — Agent 4 implementation + Library interface

---

## 6. Backlog

**Role:** The work queue. All items that need formalization live here, with their status and metadata.

### How items enter

1. **From Agent 4 (Librarian):** non-duplicate inbox items enter as PENDING
2. **From the Proving Agent:** dependencies encountered mid-proof enter as AXIOMATIZED

### Axiomatized dependencies — the key design decision

When the proving agent is formalizing theorem T and encounters a dependency D (a cited result, a "well-known" fact, a previous claim), it does **not** recurse into proving D. Instead:

```
Proving Agent hits dependency D
        │
        ▼
  Librarian: does D exist?
        │
   ┌────┴────────┐
   YES           NO
   │             │
   ▼             ▼
 Use existing   1. Add D to Lean as a labeled axiom
 Lean name      2. Add D to backlog as AXIOMATIZED
   │             │  with: dependency_type, has_citation, source
   └──────┬──────┘
          ▼
   Continue proving T (using axiom or existing lemma)
```

**This mirrors how humans learn mathematics.** When reading a paper, you accept cited results and keep going — you don't stop to prove every lemma from first principles. The axiom is a placeholder: "I accept this is true; I'll prove it later (or find it in Mathlib)."

**This avoids deep recursion.** Without this, proving one theorem could trigger an unbounded chain of dependency proofs. The axiomatize-and-continue approach keeps each proof attempt bounded.

**This gets cheaper over time.** As the knowledge tree grows, more dependencies resolve via the Librarian (already exists) instead of creating new axioms. Early runs are expensive; later runs find most dependencies already formalized.

### Dependency metadata

Each axiomatized entry tracks how the dependency was introduced:

| Field | Values | Purpose |
|-------|--------|---------|
| `dependency_type` | citation, claimed_known, previous_claim, implicit | How the source text referenced it |
| `has_citation` | bool | Does it cite a specific paper/theorem? |
| `citation_source` | str | e.g., "Milgrom & Shannon 1994, Theorem 2" |
| `lean_axiom_name` | str | The axiom name in Lean (for later replacement) |
| `created_during` | str | Which theorem's proof created this axiom |

This metadata is valuable for prioritization: cited dependencies with known sources are easier to resolve (we know where to look) than implicit ones.

### Status flow

```
add() ──→ READY ──→ IN_PROGRESS ──→ COMPLETED (with .lean file)
                          │
                          ├──→ FAILED (with reason)
                          │
                          └──→ AXIOMATIZED (dependency placeholder)

AXIOMATIZED items can later be picked up and moved to
IN_PROGRESS → COMPLETED as the library grows.
Items are NEVER blocked — the prover axiomatizes deps at proof time.
```

### Key files

- `src/leanknowledge/backlog.py` — Backlog store + BacklogEntry, DependencyInfo schemas

---

## 7. Agent 5 — Proof Structurer (INACTIVE)

> **Status:** Agent 5 is **no longer called in the pipeline**. The code still exists but is bypassed entirely. The direct-to-guided path (see §8) works better without it.

**Original role:** Transform a natural-language proof into a highly structured proof plan that makes the translator's job mechanical.

### Why it was removed

Structured proof plans **over-constrain the translation models**. When a model receives a 50-line JSON plan saying "Step 1: apply limit definition, Step 2: factor out exp(x)...", it follows that plan slavishly instead of reaching for a direct Mathlib lemma like `simp [Real.deriv_exp]`. Empirically, giving models just the theorem statement plus the NL proof and letting them use their own knowledge of Mathlib produces better results.

The two-phase translator (§8) now passes the NL proof directly to the model in both phases, along with all prior failure history. This gives the model the mathematical context it needs without locking it into a specific proof strategy.

### Original design (preserved for reference)

The agent produced a `StructuredProof` with: strategy, goal statement, named assumptions, dependencies, atomic steps (each ~1 Lean tactic), and tactic hints. The prompt (`prompts/proof_structurer.md`) contained all the intelligence. It required a strong reasoning model (Opus by default).

### Key files (still in codebase, inactive)

- `src/leanknowledge/agents/proof_structurer.py` — Agent 5 implementation (not called)
- `prompts/proof_structurer.md` — System prompt (inactive)

---

## 8. Agent 6 — Translator

**Role:** Convert theorems into compilable Lean 4 code, with two-phase, three-tier escalation and training data collection.

### Two-phase, three-tier translation

The key insight: giving models a detailed step-by-step proof plan (Agent 5's StructuredProof) can actually *degrade* their performance. When a model receives a 50-line JSON plan saying "Step 1: apply limit definition, Step 2: factor out exp(x)...", it follows that plan slavishly instead of reaching for a direct Mathlib lemma like `simp [Real.deriv_exp]`.

The fix: **try without a plan first** (direct mode), then escalate with the NL proof and full failure history (guided mode). **Agent 5 is not called at any point.**

```
ExtractedItem (theorem + NL proof)
      │
      ▼
┌─────────────────────────────┐
│  Phase 1: DIRECT            │  3 attempts with DeepSeek.
│  (no plan, no Agent 5)      │  Just the theorem statement + NL proof.
│                             │  Leverages the model's own knowledge.
└─────────────┬───────────────┘
              │
        compiled? ──yes──→ SUCCESS
              │
              no (3× exhausted)
              │
              ▼
┌─────────────────────────────┐
│  Phase 2: GUIDED            │  NL proof + all prior failures.
│  (no Agent 5 — just         │  No structured plan — the model gets
│   escalation with context)  │  the NL proof and decides its own approach.
│                             │
│  Tier 1: DeepSeek Reasoner  │  7 attempts. Full history + NL proof.
│  Tier 2: Gemini 2.5 Pro     │  5 attempts. Full history + NL proof.
└─────────────┬───────────────┘
              │
        compiled? ──yes──→ SUCCESS
              │
              no (12× exhausted)
              │
              ▼
┌─────────────────────────────┐
│  Tier 3: DECOMPOSITION      │  Decompose into 2-5 sub-lemmas.
│  (hard theorem path)        │  Prove each independently (3× each).
│                             │  Assemble into final theorem.
│                             │  Partial success = training data.
└─────────────┬───────────────┘
              │
        assembled? ──yes──→ SUCCESS
              │
              no
              │
              ▼
        NEEDS_HUMAN (flagged for manual attention)
```

**Total budget:** 3 direct + 7 Tier 1 + 5 Tier 2 + 1 Tier 3 decomposition = **16 attempts max**. Direct phase is cheap (DeepSeek) and fast. When it succeeds, the theorem is done in seconds. When it fails, the failures provide useful context for guided escalation.

**CRUCIAL:** Each attempt carries the FULL history of all previous attempts — including cross-phase. Direct failures appear in guided retry prompts, so the model sees both unguided and guided approaches.

### Tier 3: Hard theorem decomposition

When tiers 1-2 all fail (15 monolithic attempts exhausted), a decomposer model breaks the theorem into 2-5 independent sub-lemmas with Lean type signatures. Each sub-lemma is proved independently. If all sub-lemmas compile, they're assembled into the final theorem.

**Why this works:** The models know the *math* but can't get a 20-line proof right in one shot. Breaking into 3-line sub-lemmas gives each piece a much higher success probability. Even partial success (3/4 sub-lemmas compile) generates valuable training triples.

The decomposer sees all 15 failed attempts, so it avoids the same Mathlib identifiers that didn't work. Sub-lemma model tags include `[sub:name]` for analysis.

### Training triples

Every attempt — successful or not — produces a triple:

```
(StructuredProof, Lean code, compiler output)
```

These triples serve two training purposes:

1. **Train the translator** (RL): learn to produce Lean that compiles
2. **Train the structurer** (supervised): learn which proof structures lead to successful translations

This is analogous to **AlphaGo's training approach**:
- **Supervised learning** from the Rosetta Stone corpus ≈ learning from expert games
- **Self-play RL** from compiler feedback ≈ learning by playing against yourself
- **Multi-attempt search** with history ≈ Monte Carlo tree search at inference time

The compiler is a perfect reward signal — binary, deterministic, and free. Unlike NL tasks where evaluation is fuzzy, here success is unambiguous: it either compiles or it doesn't.

### Goedel-Prover (removed from pipeline)

**Base model:** `Goedel-LM/Goedel-Prover-V2-8B` (Qwen3-8B variant, ~16GB). A QLoRA adapter (`translator_v0`) was trained on 199,613 NL proof → Lean 4 pairs. It achieved **0% compilation success** across all pilot runs and was removed from the pipeline.

**Current status:** The pipeline uses only cloud API models (DeepSeek + Gemini), eliminating the need for a GPU VM. Training triples from 1,435 verified proofs (Runs 7-8) are being collected for future RL retraining. If a retrained adapter demonstrates meaningful compilation success, Goedel-Prover would be reintroduced as a cost-effective Tier 0 before DeepSeek.

### Key files

- `src/leanknowledge/agents/translator.py` — Agent 6 implementation + TranslationTriple + Tier 3 decomposition
- `prompts/translator.md` — System prompt for guided mode (iterate here)
- `prompts/decomposer.md` — System prompt for Tier 3 decomposition

---

## 8.5. Prompt Tuner

**Role:** Learn from compilation failures across a run and inject "lessons learned" into the translator's system prompt, so later theorems avoid mistakes that earlier theorems hit.

The Prompt Tuner sits between the Pipeline orchestrator and Agent 6 (Translator). It is not a separate agent — it augments Agent 6's system prompt with targeted advice based on observed failure patterns.

### Two-layer architecture

```
                    ┌──────────────────────────┐
                    │     Static Rules          │  Hand-written from pilot observations.
                    │  (always available)       │  Triggered by regex on compiler errors.
                    └────────────┬─────────────┘
                                 │
                    ┌────────────▼─────────────┐
                    │    Dynamic Patterns       │  Extracted from training triples.
                    │  (learned per-run)        │  Surfaces errors seen ≥2 times.
                    └────────────┬─────────────┘
                                 │
                                 ▼
                    ┌──────────────────────────┐
                    │   "LESSONS LEARNED"       │  Injected into translator's
                    │   section in system       │  system prompt per-attempt.
                    │   prompt                  │
                    └──────────────────────────┘
```

### Static rules

Hand-written rules seeded from pilot run observations. Each rule has:
- A **name** and **description** (injected as advice text)
- A **regex trigger** — matched against compiler error strings
- A **priority** (higher = appears earlier in the prompt)

| Rule | Trigger pattern | What it teaches |
|------|-----------------|-----------------|
| `lean3_sum_syntax` | `unexpected token 'in'` | NEVER use `∑ i in` — use `∑ i ∈` (Lean 4 syntax) |
| `lean3_prod_syntax` | `unexpected token 'in'` | Same for `∏` notation |
| `nat_division` | `rewrite failed.*/ in` | ℕ division is FLOOR division — avoid or cast to ℚ |
| `hallucinated_ident` | `Unknown constant\|unknown identifier` | Do NOT guess Mathlib names — use `exact?` or `apply?` |
| `deprecated_api` | `has been deprecated` | Check for API changes in current Mathlib |
| `rewrite_pattern_mismatch` | `rewrite.*did not find` | Verify rewrite target matches exactly |
| `empty_code` | `empty or vacuous code` | Must produce a `theorem`/`lemma`/`def` declaration |
| `general_lean4` | *(always included)* | Import `Mathlib`, use `by` tactic blocks, prefer `simp`/`omega`/`linarith` |

### Dynamic pattern extraction

After each theorem attempt, the Pipeline feeds all training triples to the Tuner via `ingest_triples()`. The Tuner:

1. **Normalizes** error messages — strips file paths, line numbers, and specific identifiers
2. **Buckets** errors by normalized message
3. **Surfaces patterns** seen ≥2 times as `ErrorPattern` objects (with count and example)

These patterns appear in a "Recurring errors in this run" section of the lessons output, alerting the model to systematic issues it may be repeating.

### Integration with Agent 6

The Tuner is created once per Pipeline run and shared across all theorem translations:

```python
# Pipeline.__init__
self.tuner = PromptTuner()
self.translator = TranslatorAgent(compiler=self.compiler, tuner=self.tuner)

# After each theorem
self.tuner.ingest_triples(triple_dicts)  # learn from this theorem's attempts
```

Within `TranslatorAgent._try_tier()`, the system prompt is refreshed on each attempt:

```python
current_errors = [t.compiler_output for t in triples if not t.compiled]
lessons = self.tuner.get_lessons(current_errors)
system = f"{base_system}\n\n{lessons}"
```

This means:
- **Attempt 1:** gets general lessons + any patterns from previous theorems
- **Attempt N:** gets lessons boosted by *this theorem's* specific errors
- **Later theorems:** benefit from all earlier theorems' failures

### Priority boosting

Rules are ranked by effective priority = base priority + historical trigger count + current error match bonus. This ensures:
- Rules that fire often (common mistakes) float to the top
- Rules matching the current theorem's errors get extra weight
- General advice stays at lower priority but is always included

### ProofWiki pilot results

The Prompt Tuner was built after analyzing a 5-theorem pilot run on ProofWiki (Number Theory category):

| Theorem | Result | Attempts | Key failure |
|---------|--------|----------|-------------|
| Euclid's Theorem | SUCCESS | 4 (DeepSeek) | Lean 3 syntax on attempts 1-3 |
| Derivative of exp | SUCCESS | 8 (Sonnet) | Hallucinated Mathlib names on attempts 1-7 |
| Sum of First N | FAILED | 10 | ℕ floor division |
| Fermat's Little | FAILED | 10 | Hallucinated `ZMod.fermat_little` |
| Binomial Theorem | FAILED | 10 | ℕ floor division + wrong syntax |

**2/5 (40%) success rate.** The static rules directly address the three main failure categories observed.

### Key files

- `src/leanknowledge/prompt_tuner.py` — Prompt Tuner implementation (Rule, ErrorPattern, PromptTuner)
- `prompts/translator.md` — Base translator prompt (includes "Critical mistakes to avoid" section)

---

## 8.6. ProofWiki Adapter

**Role:** Load theorems from the NaturalProofs ProofWiki dataset and feed them directly into the formalization pipeline (Agent 6), bypassing Agents 1-5 since the content is already structured.

The ProofWiki dataset (from Zenodo) contains 19,734 theorems with 17,911 having full proofs. It provides a large-scale benchmark for the pipeline without needing PDF extraction or claim identification.

```
naturalproofs_proofwiki.json (111 MB)
        │
        ▼
┌───────────────────┐
│  ProofWiki Adapter │   Clean wiki markup, classify labels,
│  (load_proofwiki)  │   resolve dependency refs → ExtractedItem
└───────────┬───────┘
            │
            ▼  (skip Agents 1-4)
┌───────────────────┐
│     Backlog       │   Items enter as READY with category tag
└───────────┬───────┘
            │
            ▼
┌───────────────────┐
│     Agent 6       │   Two-phase translation (Agent 5 bypassed)
└───────────────────┘
```

Supports filtering by category (`--category "Number Theory"`), limiting count (`--max 10`), and resuming from saved backlog.

### Key files

- `src/leanknowledge/proofwiki.py` — Dataset loader + wiki markup cleaning
- `scripts/run_proofwiki.py` — Batch runner with resume support + Prompt Tuner integration
- `scripts/download_proofwiki.py` — Downloads dataset from Zenodo

---

## 9. Agent 7 — Knowledge Agent (PLANNED)

**Role:** After a theorem is successfully formalized, analyze the verified Lean code to extract structured metadata. No LLM calls — fully deterministic, regex-based analysis of compiled Lean output.

**Two outputs:**

### 9.1 Reference graph

A directed graph of relationships between formalized items. Edges are extracted from the verified Lean code (imports, invocations) and from the backlog's dependency metadata.

```
KnowledgeNode:
  theorem_name: str
  domain: str
  tags: list[str]              # proof method tags from tactics used
  lean_dependencies: list[str]  # extracted from imports + Mathlib references
  semantic_connections: list[str]  # cross-domain links (inferred from dependency domains)
```

**Edge types:**

| Edge | Source | Example |
|------|--------|---------|
| `depends_on` | Lean imports + `exact`/`apply` targets | "Prop_3D2 depends_on Mathlib.Order.CompleteLattice" |
| `axiomatized_for` | Backlog's DependencyInfo | "axiom_mcs axiomatized_for Thm_5" |
| `cross_domain` | Module path → domain mapping | "Prop_3D2 (microeconomics) uses Topology.IsCompact" |

The graph enables: "what breaks if we change this lemma?", "what's the most-depended-on unproved result?", "which domains have cross-connections?"

**Tactic tagging** — deterministic mapping from Lean tactics to human-readable method labels:

```
by_contra → contradiction     calc → calculational_proof
induction → induction         simp → simplification
linarith → linear_arithmetic  omega → arithmetic
rcases → case_analysis        ext → extensionality
```

These tags feed back into the Strategy KB (below) and make the knowledge graph searchable by proof technique.

### 9.2 Strategy Knowledge Base

A growing database of "what works" — records from every successful formalization. Used by Agent 6 (Translator) to make better first-attempt choices.

```
StrategyEntry:
  theorem_id: str
  domain: str
  mathematical_objects: list[str]   # concepts involved
  proof_strategies: list[str]       # e.g. ["direct", "compactness_argument"]
  lean_tactics_used: list[str]      # what compiled
  lean_tactics_failed: list[str]    # what didn't (from earlier attempts)
  difficulty: str                   # easy/medium/hard (based on iteration count)
  iterations_to_compile: int
  error_types_encountered: list[str]
  dependencies_used: list[str]      # Lean declarations referenced
```

**How it feeds back:**

- **Agent 6 (Translator):** "For topology theorems, proofs using `IsCompact` frequently need `linarith` and `exact`." → includes as tactic hints in the translation prompt.
- **Repair DB:** "Type mismatch errors on `↑` casts are common for ℕ→ℤ coercions in number theory." → preemptive cast insertion.

**Why deterministic?** The Knowledge Agent runs on *verified* Lean code — the compiler has already confirmed correctness. Extracting imports, tactics, and module paths from correct code is a parsing task, not a reasoning task. Regex is faster, cheaper, and deterministic. The Previous codebase proved this works (~200 lines of code, no LLM calls).

**When to build:** After the pipeline has produced its first batch of successful formalizations. The Strategy KB only becomes useful with data — there's no value in building it before the pipeline runs end-to-end. The Knowledge Agent itself is small (~200 lines); the value is in the accumulated data.

---

## 10. OpenAlex Citation Graph

**Role:** Map the entire field of microeconomic theory using OpenAlex's academic database. Build a citation graph, rank papers by influence (PageRank), and identify which papers to formalize first.

### Data pipeline

```
OpenAlex API --> papers.jsonl (364K papers)
    --> citation_graph.json (nodes + internal edges)
    --> ranked_papers.json (PageRank scores + metadata)
    --> pdfs/ (open-access downloads for top N)
```

### Graph construction

Papers are fetched by concept (Microeconomics = `C175444787`) with a citation floor (e.g., >10 citations). Citation edges are resolved by set intersection — only edges between papers in our set are included, requiring no extra API calls.

### Why PageRank over raw citations?

Raw citation count favors review papers and old papers. PageRank captures *structural influence* — a paper cited by many influential papers ranks higher than one cited by many obscure papers. This surfaces foundational results that the field builds on.

### Current data

| Threshold | Papers | Internal edges |
|-----------|--------|----------------|
| >100 citations | 53,559 | 346,458 |
| >50 citations | 114,475 | 820,027 |
| >10 citations | 364,651 | 2,708,923 |

### Key files

- `src/leanknowledge/openalex.py` — Core module: `OpenAlexClient`, `Paper`, `RankedPaper`, `build_citation_graph()`, `rank_papers()`, `download_pdfs()`, `load_openalex()`
- `scripts/fetch_openalex.py` — CLI: `fetch`, `rank`, `download-pdfs`, `stats`, `all`

---

## 11. Open Design Questions

### Librarian — Semantic Search
- Three-layer stack designed (see §5): embeddings → Loogle → LLM fallback
- Needs the Rosetta Stone embedding index built first (~30 min batch job)
- `Library` interface already supports swappable backends

### Definition formalization
- Definitions enter the backlog as READY but are skipped by `formalize_next()` (no proof to structure)
- They need a separate path: statement → Lean `def`/`structure`/`class` (no Agent 5, different Agent 6 prompt)
- Lower priority than theorems but needed for completeness

---

## 12. Summary — Current State

### What's built (~280 tests passing)

| # | Component | Role | Implementation |
|---|-----------|------|---------------|
| 1 | Extraction | PDF → text | PyMuPDF + Google DocAI escalation |
| 2 | Claim Extraction | text → claims | Sonnet + DeepThink ensemble, Opus arbiter |
| 3 | Triage | classify → inbox | Deterministic (no LLM) |
| 4 | Librarian | dedup gate → backlog | Pluggable Library interface |
| 5 | Proof Structurer | NL proof → structured plan | **Inactive** — structured plans degraded model performance (see §7) |
| 6 | Translator | theorem → Lean 4 | Two-phase, three-tier: Direct (3× DeepSeek) → Tier 1 (7× DeepSeek) → Tier 2 (5× Gemini 2.5 Pro) → Tier 3 Decompose (16 attempts max) |
| — | Pre-compiler | deterministic Lean code fixes | Import management, identifier validation (207K Mathlib index), class/API renames, scoped notation |
| — | Prompt Tuner | learn from failures → better prompts | Static rules + dynamic pattern extraction from triples |
| — | Mathlib Index | RAG for real Mathlib declarations | 207K declarations, multi-query search (goal + NL proof + error-driven), fuzzy matching |
| — | ProofWiki Adapter | NaturalProofs dataset → backlog | 17,911 theorems, bypasses Agents 1-4 |
| — | Backlog | work queue | No blocking — axiomatize at proof time. Dependency tracking for info only |
| — | Lean compiler | `lean` binary wrapper | REPL (cached paths) + cold start, error parsing, 3-tier repair DB |
| — | Config | model routing + roll call | TOML config files, env var overrides, pre-run model identity verification |
| — | Pipeline | orchestrator + CLI | `extract`, `next`, `run`, `status`. Training triple collection |
| — | Pool runner | parallel formalization | File-locked work queue, 20 workers, auto-requeue operational failures (up to 3 retries) |
| — | OpenAlex client | citation graph | 364K papers, 2.7M edges, PageRank ranking, PDF download |

### Benchmark results (ProofWiki)

Early runs (1-6) established the architecture. Runs 7-8 are the production results:

- **Run 5 (two-phase, Goedel removed, 26 Number Theory):** 25/26 = 96%. Validated the two-phase approach and Tier 3 decomposition.
- **Run 7 (1,000 theorems, all categories, Gemini 2.5 Pro via Vertex AI):** 8 pool workers. **864/896 attempted = 96.4%** (104 rerouted/skipped). Cost: ~$107.
- **Run 8 (1,000 NEW theorems, disjoint set, DeepSeek + Gemini tiered):** 20 pool workers. **571/1,000 = 57.1%.** Harder theorem mix (Run 7 skimmed the easier theorems first).
- **Combined (Runs 7-8):** 2,000 theorems, **1,435 proved, 75.7% of 1,896 attempted.**

Key statistics (combined):
- **432 one-shot successes (30.8%)** — proved on the first attempt
- Average 5.0 attempts per success, median 3
- DeepSeek produced **88% of winning proofs** (cheap + effective)
- Top error categories: parse errors (28%), hallucinated identifiers (24%), function_expected (11%), unsolved goals (10%)

Category breakdown (combined success rates):
- Group Theory: 90.4%, Set Theory: 89.7%, Relations: 84.1%, Logic: 83.8%
- Probability: 26.1%, Trigonometry: 41.1% (hardest categories)

Key findings:
- **The structured proof plan was making models worse.** Direct mode — just the theorem statement + NL proof — lets models use their own knowledge of Mathlib lemmas instead of following an over-specified plan.
- **Tier 3 decomposition unlocks hard theorems.** Theorems that failed all 15 monolithic attempts (FTA, Basel Problem, √2 Irrational) were solved by breaking into 2-5 sub-lemmas.
- **The #1 failure mode is hallucinated Mathlib identifiers** — addressed by Mathlib RAG index (207K declarations) injected into prompts, error-driven search (extracts hallucinated names from compiler errors, finds closest real match), and pre-compiler fuzzy matching.
- **Operational failures must be auto-requeued.** Run 7 discovered that 155/180 initial failures were operational (missing olean from a pre-compiler bug, API errors, crashes), not genuine proof difficulty. The runner now auto-requeues operational failures (up to 3 retries).

### Parallel execution

Pool-based work stealing via `scripts/run_proofwiki.py --pool`. Workers share a `work_queue.json` file (file-locked), claiming one theorem at a time. Each worker gets a unique scratch file (`Scratch_0.lean`, `Scratch_1.lean`, ...) to avoid Lean compiler conflicts. Auto-requeue handles transient API errors and operational compiler failures.

### Pre-compiler

Deterministic pre-compilation pass (`lean/pre_compiler.py`) that validates and fixes Lean code before sending to the compiler:

- **Import management:** Ensures `import Mathlib` is present, strips redundant submodule imports (`import Mathlib.X.Y.Z`)
- **Identifier validation:** Fuzzy-matches qualified names against the 207K-entry Mathlib index, replaces hallucinated identifiers with closest real match
- **Class renames:** Fixes deprecated class names (e.g., `OrderedRing` → `IsOrderedRing`)
- **API renames:** Fixes known API name changes (e.g., `Int.ediv_add_emod` → `Int.mdiv_add_mmod`)
- **Scoped notation:** Adds `open scoped symmDiff` for symmetric difference notation
- **Deprecated patterns:** Replaces `ExistsUnique` with `∃!`

Fixes are applied silently and don't count as an attempt — the pre-compiler improves code before it reaches the compiler.

### Configuration and model roll call

Model assignments are centralized in `run_config.toml` (see also `run_config_free.toml` for zero-cost CLI profiles). The config system (`config.py`) loads a TOML file, applies environment variable overrides, and patches already-imported module globals — so the config takes effect even though agent modules read their defaults at import time.

Before any token-spending command, the pipeline runs a **model roll call**: it sends a lightweight identity probe to each unique configured model. Each model responds with its self-reported name and version. This catches:
- **Typos in model strings** that silently fall back to a default model
- **Connectivity issues** (missing API keys, unreachable endpoints, CLI tools not installed)
- **Wrong model versions** (e.g., configuring Sonnet but getting Opus due to a default)

The roll call displays a table showing what was configured vs. what actually responded, and prompts for confirmation before proceeding. Use `--yes` to skip the prompt or `--skip-roll-call` to skip entirely.

### What's not built yet (designed, see §9-11)

- Microeconomics formalization runs (top PageRank papers, economics-specific prompts)
- Agent 7 (Knowledge Agent): deterministic tactic tagging + reference graph + strategy KB (waiting for first pipeline output)
- Librarian semantic search: three-layer stack (embeddings → Loogle → LLM)
- Definition formalization path (different translation prompt, no proof structurer)
- Rosetta Stone embedding index (batch build from 222K pairs)
