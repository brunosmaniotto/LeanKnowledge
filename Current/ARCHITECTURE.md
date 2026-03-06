# LeanKnowledge — Architecture

## 1. What This System Does

LeanKnowledge is a multi-agent pipeline that reads mathematical texts (textbooks and research papers), extracts mathematical claims, and produces machine-verified formal proofs in Lean 4. It organizes the results into a growing knowledge graph and accumulates training data for specialized theorem-proving models.

The core thesis: **formalizing known mathematics is a translation problem, and LLMs are good at translation.** Rather than chasing novel proofs, we systematically convert centuries of proven results into machine-verified code — building the infrastructure that future automatic provers need.

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

### Model defaults (via LiteLLM)

All LLM calls go through a unified LiteLLM gateway. Defaults:

| Role | Env var | Default |
|------|---------|---------|
| Fast model A | `LK_MODEL_FAST_A` | `anthropic/claude-sonnet-4-20250514` |
| Fast model B | `LK_MODEL_FAST_B` | `deepseek/deepseek-reasoner` |
| Heavy model | `LK_MODEL_HEAVY` | `anthropic/claude-opus-4-20250115` |

Any LiteLLM-compatible model string works. Swap providers by changing env vars.

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

### Dependency resolution

When an item enters the backlog, its `dependencies` list is checked:
- **All resolved** (COMPLETED, AXIOMATIZED, or not in backlog) → READY
- **Some unresolved** (in backlog but not yet proved) → BLOCKED
- Dependencies **not in the backlog** are treated as external (Mathlib, etc.) and assumed resolved. The prover will axiomatize them if needed.

When an item is completed or axiomatized, all BLOCKED items are re-checked. This cascades: completing C can unblock B, which (once completed) unblocks A.

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

**Production target: three-layer semantic search.**

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
         ┌─→ READY ──→ IN_PROGRESS ──→ COMPLETED (with .lean file)
add() ───┤                  │
         └─→ BLOCKED        ├──→ FAILED (with reason)
               ↑    │       │
               │    ↓       └──→ AXIOMATIZED (dependency placeholder)
               └── (re-check when deps resolve)

AXIOMATIZED items can later be picked up and moved to
IN_PROGRESS → COMPLETED as the library grows.
Completing or axiomatizing an item propagates to unblock dependents.
```

### Key files

- `src/leanknowledge/backlog.py` — Backlog store + BacklogEntry, DependencyInfo schemas

---

## 7. Agent 5 — Proof Structurer

**Role:** Transform a natural-language proof into a highly structured proof plan that makes the translator's job mechanical.

This agent does all the mathematical thinking. The downstream translator should be able to convert each step into 1-2 Lean tactics without needing to "figure out" any math.

### Input → Output

```
ExtractedItem (theorem + NL proof)
        │
        ▼
┌───────────────────────┐
│  Agent 5: Structurer  │   Strong reasoning model (Opus by default)
└───────────┬───────────┘
            ▼
    StructuredProof:
      - strategy (direct / contradiction / induction / construction / cases)
      - goal_statement (with all quantifiers explicit)
      - assumptions (named, with Lean type hints)
      - dependencies (named, sourced, with usage notes)
      - steps (atomic, each ≈ one Lean tactic)
        - step_number, description, justification
        - objects_introduced
        - lean_tactic_hint
        - substeps (for complex reasoning)
      - conclusion
```

### Design philosophy

**The intelligence is in the prompt, not the code.** The agent is a thin LLM wrapper. The prompt (`prompts/proof_structurer.md`) is a living document designed to be iterated on as we learn what makes the translator succeed or fail.

The prompt includes an "Iteration notes" section at the bottom for recording what works and what doesn't — a changelog for prompt engineering.

### Key rules enforced by the prompt

1. **Atomic steps** — each step = one logical move ≈ one Lean tactic
2. **Name everything** — no "by a previous result", always the specific name
3. **Explicit quantifiers and types** — "for all x : X" not "for any element"
4. **Strategy declared upfront** — determines the proof skeleton
5. **Lean tactic hints** — suggested tactic per step (hint, not requirement)
6. **Dependencies fully specified** — name, statement, source, which step uses it

### Model choice

Defaults to `LK_MODEL_HEAVY` (Opus). This agent needs strong mathematical reasoning — it's understanding the proof, not just reformatting it. Not a good candidate for fine-tuning (too variable, low volume).

### Key files

- `src/leanknowledge/agents/proof_structurer.py` — Agent 5 implementation (thin)
- `prompts/proof_structurer.md` — System prompt (where the intelligence lives, iterate here)

---

## 8. Agent 6 — Translator

**Role:** Convert a StructuredProof into compilable Lean 4 code, with escalation and training data collection.

### Escalation system

```
StructuredProof
      │
      ▼
┌─────────────────────────────┐
│  Tier 1: DeepSeek           │  Up to 5 attempts.
│  (fine-tuned Goedel-Prover) │  Each attempt sees all previous failures.
└─────────────┬───────────────┘
              │
        compiled? ──yes──→ SUCCESS
              │
              no (5× exhausted)
              │
              ▼
┌─────────────────────────────┐
│  Tier 2: Opus               │  Up to 5 attempts.
│                             │  Sees ALL previous attempts (incl. Tier 1).
└─────────────┬───────────────┘
              │
        compiled? ──yes──→ SUCCESS
              │
              no (5× exhausted)
              │
              ▼
        NEEDS_HUMAN (flagged for manual attention)
```

**CRUCIAL:** Each attempt carries the FULL history of all previous attempts and their compiler outputs. The model never tries blindly — it sees "we tried X, the compiler said Y" for every prior attempt. This is what makes later attempts more informed than earlier ones.

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

### Goedel-Prover fine-tuning

**Base model:** `Goedel-LM/Goedel-Prover-V2-8B` — a Qwen3-8B variant specialized for theorem proving (~16GB, auto-downloads from HuggingFace).

**Current adapter:** `translator_v0` — QLoRA adapter trained on 199,613 NL proof → Lean 4 pairs from the Rosetta Stone training split. Loading both together gives Goedel's base mathematical reasoning fine-tuned to our specific translation format.

**Progressive training:**

```
Rosetta Stone (222K pairs) ──→ translator_v0 (current)
         +
Translation triples ──→ RL fine-tune (compiler reward) ──→ translator_v1
         +
New verified proofs ──→ Rosetta Stone grows ──→ translator_v2 ...
```

Each version of the translator produces triples that train the next version. The Rosetta Stone grows with every successful formalization, providing more supervised data.

### Key files

- `src/leanknowledge/agents/translator.py` — Agent 6 implementation + TranslationTriple
- `prompts/translator.md` — System prompt (iterate here)

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

A growing database of "what works" — records from every successful formalization. Used by Agent 5 (Proof Structurer) and Agent 6 (Translator) to make better first-attempt choices.

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

- **Agent 5 (Proof Structurer):** "For topology theorems, `contradiction` strategy succeeds 80% of the time in ≤3 iterations. `direct` strategy only 40%." → influences strategy choice.
- **Agent 6 (Translator):** "Proofs using `IsCompact` frequently need `linarith` and `exact`." → includes as tactic hints in the translation prompt.
- **Repair DB:** "Type mismatch errors on `↑` casts are common for ℕ→ℤ coercions in number theory." → preemptive cast insertion.

**Why deterministic?** The Knowledge Agent runs on *verified* Lean code — the compiler has already confirmed correctness. Extracting imports, tactics, and module paths from correct code is a parsing task, not a reasoning task. Regex is faster, cheaper, and deterministic. The Previous codebase proved this works (~200 lines of code, no LLM calls).

**When to build:** After the pipeline has produced its first batch of successful formalizations. The Strategy KB only becomes useful with data — there's no value in building it before the pipeline runs end-to-end. The Knowledge Agent itself is small (~200 lines); the value is in the accumulated data.

---

## 10. Open Design Questions

### Librarian — Semantic Search
- Three-layer stack designed (see §5): embeddings → Loogle → LLM fallback
- Needs the Rosetta Stone embedding index built first (~30 min batch job)
- `Library` interface already supports swappable backends

### Definition formalization
- Definitions enter the backlog as READY but are skipped by `formalize_next()` (no proof to structure)
- They need a separate path: statement → Lean `def`/`structure`/`class` (no Agent 5, different Agent 6 prompt)
- Lower priority than theorems but needed for completeness

---

## 10. Summary — Current State

### What's built (124 tests passing)

| # | Component | Role | Implementation |
|---|-----------|------|---------------|
| 1 | Extraction | PDF → text | PyMuPDF + Google DocAI escalation |
| 2 | Claim Extraction | text → claims | Sonnet + DeepThink ensemble, Opus arbiter |
| 3 | Triage | classify → inbox | Deterministic (no LLM) |
| 4 | Librarian | dedup gate → backlog | Pluggable Library interface |
| 5 | Proof Structurer | NL proof → structured plan | Opus, prompt-driven |
| 6 | Translator | structured proof → Lean 4 | 5× DeepSeek → 5× Opus → human flag |
| — | Backlog | work queue | Dependency resolution (READY/BLOCKED), axiomatized tracking |
| — | Lean compiler | `lean` binary wrapper | REPL (cached paths) + cold start, error parsing, 3-tier repair DB |
| — | Pipeline | orchestrator + CLI | `extract`, `next`, `run`, `status`. Training triple collection |

### What's not built yet (designed, see §9-10)

- Agent 7 (Knowledge Agent): deterministic tactic tagging + reference graph + strategy KB (waiting for first pipeline output)
- Librarian semantic search: three-layer stack (embeddings → Loogle → LLM)
- Definition formalization path (different translation prompt, no proof structurer)
- Rosetta Stone embedding index (batch build from 222K pairs)
