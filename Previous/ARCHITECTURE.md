# LeanKnowledge — System Documentation

## 1. What This System Does

LeanKnowledge is a multi-agent pipeline that reads mathematical texts (textbooks and research papers), extracts mathematical claims, and produces machine-verified formal proofs in Lean 4. It organizes the results into a growing knowledge tree of formalized mathematics and accumulates training data for a future custom theorem-proving model.

The initial domain is microeconomic theory, starting from preference relation foundations (Mas-Colell, Whinston, and Green) and working toward formalizing research papers such as Milgrom and Shannon (1994) on monotone comparative statics.

---

## 2. Architecture Overview

The system consists of:
- **Eight agents**: PDF Reader, Librarian, Feeder, Proof Agent, Translator, Verifier/Proof Search, Knowledge Agent, Resolver
- **One router**: dispatches claims to the pipeline or the backlog
- **Four persistent resources**: Knowledge Tree, Dependency Backlog, Rosetta Stone, Strategy Knowledge Base
- **One training flywheel**: collects supervised pairs, failure triples, and search trajectories

There is no "mode switch." The system behaves the same regardless of input. When a textbook chapter is fed in, most claims come with proofs and flow through the pipeline (bottom-up behavior emerges). When a research paper is fed in, many claims lack proofs and go to the backlog (top-down behavior emerges). The two dynamics meet in the middle: textbook work resolves backlog items that papers created, and the backlog reveals which foundations to prioritize.

### Prototype vs. Production

In the current prototype, all agents run via Claude Code CLI (`claude -p`). In production, each agent uses the backend best suited to its task:

| Agent | Prototype | Production | Rationale |
|---|---|---|---|
| Stage 0 (Extraction) | Claude Code CLI (text) | Claude API (text-only) | Marker pre-converts PDF → markdown; extraction is text-only, no vision needed |
| Router | Claude Code CLI | Claude API or rule-based | Simple dispatch logic, could be partially programmatic |
| Librarian | Claude Code CLI | Claude API + programmatic search | Needs mathematical reasoning + Loogle/Rosetta Stone index |
| Feeder | Not built | Claude API + web/PDF tools | Needs reasoning about source material, low volume |
| Stage 1 (Proof Agent) | Claude Code CLI | Claude API | High reasoning, low volume, too variable for fine-tuning |
| Stage 2 (Translator) | Claude Code CLI | **Fine-tuned Goedel-Prover-V2 8B** | High throughput (50-100 candidates), trainable on Rosetta Stone |
| Stage 3 (Verifier) | Claude Code CLI | Lean compiler + **RL-trained repair model** | Deterministic verification + learned repair heuristics |
| Stage 4 (Knowledge Agent) | Claude Code CLI | Claude API | High reasoning, integration, strategy tagging |
| Resolver | Claude Code CLI | Heavy reasoning model (o3, Gemini extended) | Hard proofs need deep thinking, low volume |

The key transition: **Claude Code CLI → Claude API** for most agents (removes the overhead of spawning CLI processes), and **Claude → specialized local models** for the high-throughput stages (2 and 3) where the Rosetta Stone and RL training provide enough data to outperform general-purpose LLMs on this specific task.

---

## 3. The Pipeline — Step by Step

### 3.1 Stage 0 — Extraction Agent

**Role**: Extract every mathematical claim from source text, whether or not the author labeled it.

**Input**: Markdown text (pre-converted from PDF by Marker).

**Output**: A list of claim objects.

**Pre-processing**: [Marker](https://github.com/VikParuchuri/marker) converts source PDFs to clean markdown with LaTeX math in `$...$` and `$$...$$` delimiters before Stage 0 runs. This eliminates the need for vision-based extraction, OCR, or raw PDF parsing — the agent receives well-structured text with properly rendered equations. Run with `--use_llm --redo_inline_math` for best quality.

**Why it matters**: Mathematical writing is full of unlabeled assertions. "Note that the budget set is compact," "by a standard separating hyperplane argument," and "from a well-known result in real analysis" are all logical dependencies that a proof relies on. A naive parser that only finds "Theorem" or "Lemma" labels would miss most of the actual logical structure. The Extraction Agent performs semantic parsing of mathematical argumentation.

**Claim object schema**:

```json
{
  "statement": "A continuous function on a compact set attains its maximum.",
  "role": "invoked_dependency",
  "source_location": {
    "page": 47,
    "section": "3.D",
    "context": "Used in proof of Proposition 3.D.1"
  },
  "notation_in_scope": {
    "X": "consumption set, subset of R^L",
    "≿": "preference relation on X",
    "u": "utility function u: X → R"
  }
}
```

**Role types**:
- `definition` — introduces terminology or notation. "A relation ≿ is complete if for all x, y: x ≿ y or y ≿ x."
- `claimed_result` — a proposition with a proof provided in the text. This flows through the pipeline for formalization.
- `invoked_dependency` — a result used without proof, whether cited explicitly ("by Theorem 4.3 in Rudin") or gestured at vaguely ("by a well-known result"). Goes to the backlog.
- `implicit_assumption` — a condition the argument relies on without stating. "The budget set is compact" asserted in passing. Goes to the backlog.

**Implementation notes**: Since Marker handles PDF conversion, the extraction agent is text-only — no vision, no OCR, no PyMuPDF. It still needs to handle MWG's specific notation (≿, ≻, ~), cross-references like "by Proposition 3.D.1", and Marker artifacts (occasional LaTeX parsing errors, section header formatting).

---

### 3.2 Router

**Role**: For each claim object, decide what to do with it.

**Logic**:
1. Check the Knowledge Tree: is this claim already formalized? → Link to existing node, done.
2. **Ask the Librarian**: is an equivalent result already in Mathlib? → If yes, link to the Lean name and import path, done.
3. Is the claim a `definition`? → Encode in Lean, add to tree.
4. Is the claim a `claimed_result` (has a proof)? → Queue for formalization (Stages 1→2→3→4).
5. Is the claim an `invoked_dependency` or `implicit_assumption` (no proof)? → Take as given. Add to the Dependency Backlog. Move on.

**Critical rule**: The pipeline never chases a dependency. It classifies, shelves, and moves on. This prevents unbounded recursion.

---

### 3.3 Librarian Agent

**Role**: Determine whether a mathematical result already exists in Mathlib or the Knowledge Tree, and if so, return the exact Lean declaration name and import path.

**Why it exists**: Mathlib contains 210k+ theorems, and names are often non-obvious. The multivariate chain rule isn't called `multivariate_chain_rule` — it's `HasFDerivAt.comp` in `Mathlib.Analysis.Calculus.FDeriv.Comp`. Without an agent specifically responsible for library lookup, the pipeline either wastes time reproving existing results or stalls when it can't find the right Lean identifier to invoke.

**When it is consulted**:
1. **By the Router** — before any claim is queued for formalization or sent to the backlog. The Librarian's answer changes the Router's decision: if the result is already in Mathlib, there is nothing to formalize or backlog.
2. **By Stage 2 (Translator)** — during Lean code generation. When the Translator writes a proof that invokes a dependency, it needs the *exact Lean name*. "Use the chain rule" isn't valid Lean — `HasFDerivAt.comp` with the right type signature is. The Librarian translates between mathematical concepts and Lean identifiers.
3. **By Stage 3 (Verifier)** — when a compilation fails due to a missing import or unknown identifier. The Librarian can resolve "unknown identifier `chain_rule`" into "you need `import Mathlib.Analysis.Calculus.FDeriv.Comp` and the name is `HasFDerivAt.comp`."

**Search strategy** (layered, from fast to deep):
1. **Exact name search**: Query Mathlib's declaration index by name patterns and keywords.
2. **Semantic search**: Given a natural-language statement (e.g., "the derivative of a composition is the composition of derivatives"), find the matching Lean theorem even if the name is unrelated. The Rosetta Stone's NL descriptions serve as the searchable index here.
3. **Type-based search**: Given the type signature needed (e.g., something producing `HasFDerivAt (g ∘ f) ...`), search by type. Tools like Loogle and Lean's `exact?`/`apply?` tactics support this.
4. **Module-based browsing**: If the domain is known (e.g., "this is an order theory result"), browse the relevant Mathlib module hierarchy (`Mathlib.Order.*`).

**Output**: Either a match (Lean name, import path, type signature) or "not found" (claim proceeds to Router's normal logic).

**Librarian lookup result schema**:

```json
{
  "query": "A continuous function on a compact set attains its maximum.",
  "found": true,
  "lean_name": "IsCompact.exists_isMaxOn",
  "import_path": "Mathlib.Topology.Order.Basic",
  "type_signature": "IsCompact s → ContinuousOn f s → s.Nonempty → ∃ x ∈ s, IsMaxOn f s x",
  "confidence": "high",
  "notes": "Extreme Value Theorem. Also see IsCompact.exists_forall_ge for variant."
}
```

**Why this is distinct from other agents**:
- The **Router** dispatches claims but relies on the Librarian for the Mathlib lookup it needs to dispatch correctly.
- The **Feeder** finds *source material* (PDFs, textbook pages) for the pipeline to process. The Librarian searches *formalized code libraries*, not prose.
- The **Knowledge Agent** does post-hoc integration after verification. The Librarian works *before* formalization, preventing unnecessary work.

**Scaling property**: The Librarian becomes *more* valuable as the project progresses. Early on, dependencies are simple enough for the Translator to guess. As the system moves into advanced microeconomics — fixed point theorems, measure theory, topology, real analysis — dependencies reach deeper into Mathlib, names become less guessable, and the Librarian prevents the system from reproving the Brouwer fixed point theorem because it didn't know to look for `IsCompact.exists_fixedPoint_of_continuous`.

**Stays on Claude API permanently**, augmented by programmatic search tools (Loogle, declaration index, Rosetta Stone NL index). High reasoning (must understand mathematical equivalence to match a natural-language statement to a Lean theorem), moderate volume (called for every dependency, but responses are short).

---

### 3.4 Dependency Backlog

**Role**: Prioritized queue of mathematical claims the system needs but hasn't formalized.

**Three categories** (determine how the Feeder will try to resolve them):

| Category | Example | Feeder Strategy |
|---|---|---|
| **Referenced Claim** | "by Theorem 4.3 in Rudin" | Go directly to cited source |
| **Unreferenced Claim** | "by a well-known result in real analysis" | Search textbooks, Mathlib docs, references.bib |
| **Claim with Omitted Proof** | "the reader can verify that..." | Hardest — may need external proof or construction |

**Backlog entry schema**:

```json
{
  "id": "backlog_001",
  "statement": "A continuous function on a compact set attains its maximum.",
  "category": "unreferenced",
  "reference": null,
  "needed_by": ["proposition_3D1", "theorem_weierstrass_application"],
  "priority_score": 5,
  "status": "unresolved",
  "notes": "Extreme Value Theorem. Likely in Mathlib under Topology.Order or similar."
}
```

**Priority score**: Count of downstream results that depend on this claim. The higher the score, the more formalizations this claim unblocks.

**Conditional verification**: Formalized proofs may depend on backlog items. The Knowledge Tree tracks this — a node is verified but its dependency edges may point to unresolved entries. When a backlog item is eventually formalized, the chain becomes fully grounded.

---

### 3.5 Feeder Agent

**Role**: Procurement agent. Takes backlog items, finds source material containing the proof, feeds it into Stage 0.

**Does NOT formalize anything.** It finds raw material and hands it to the pipeline.

**Search strategy by category**:
- **Referenced**: Go to the cited text directly.
- **Unreferenced**: Search loaded textbooks, Mathlib documentation, Mathlib's `references.bib` (which records the textbook/paper sources that Mathlib contributors used), and known reference texts for the domain.
- **Omitted proof**: Flag for human guidance, or attempt to find the result in a more detailed source.

**Output**: Source material (PDF page, Mathlib source, or text excerpt) fed into Stage 0.

**Can flag items it cannot resolve** — these represent genuine gaps.

---

### 3.6 Stage 1 — Proof Agent

**Role**: Take a claimed result with its raw proof and produce a structured natural-language proof.

**Input**: Claim object (role = `claimed_result`) + raw proof text from the PDF.

**Output**: Structured NL proof.

```json
{
  "theorem_name": "Completeness Implies Reflexivity",
  "statement": "If a preference relation is complete, then it is reflexive.",
  "strategy": "cases",
  "assumptions": [
    "X is a set",
    "≿ is a binary relation on X",
    "≿ is complete: for all x, y in X, x ≿ y or y ≿ x"
  ],
  "conclusion": "≿ is reflexive: for all x in X, x ≿ x",
  "steps": [
    {"step": 1, "content": "Let x ∈ X be arbitrary. Goal: show x ≿ x.", "justification": "universal generalization"},
    {"step": 2, "content": "Apply completeness to the pair (x, x): we get x ≿ x ∨ x ≿ x.", "justification": "definition of completeness"},
    {"step": 3, "content": "Both disjuncts are identical — in either case, x ≿ x.", "justification": "case analysis on disjunction"},
    {"step": 4, "content": "Since x was arbitrary, ∀ x ∈ X: x ≿ x.", "justification": "universal generalization"}
  ],
  "dependencies": ["definition of completeness", "definition of reflexivity"]
}
```

**Stays on Claude API permanently.** High reasoning, low volume, too variable for fine-tuning.

**Strategy KB integration**: Before generating a proof, the Proof Agent queries the Strategy KB by mathematical objects in the theorem statement. If similar theorems have been proved before, the query returns a ranked list of strategies by success rate. The agent uses this to bias its strategy selection — instead of guessing, it starts with what has historically compiled for this type of problem. When the agent's `revise()` method is called (after verification failure), it consults the KB for alternative strategies that haven't been tried yet.

---

### 3.7 Stage 2 — Translator Agent

**Role**: Convert a structured NL proof into Lean 4 code.

**Input**: Structured NL proof from Stage 1.

**Output**: N candidate Lean 4 translations (generated with temperature sampling).

**Example output** (one candidate):

```lean
def Complete {α : Type} (R : α → α → Prop) : Prop :=
  ∀ x y : α, R x y ∨ R y x

def Reflexive {α : Type} (R : α → α → Prop) : Prop :=
  ∀ x : α, R x x

theorem complete_implies_reflexive {α : Type} (R : α → α → Prop)
    (hR : Complete R) : Reflexive R := by
  intro x
  have h := hR x x
  cases h with
  | inl h => exact h
  | inr h => exact h
```

**Prototype**: Claude Code generates candidates.

**Production**: Fine-tuned Goedel-Prover-V2-8B (Qwen3-8B base, expert-iteration trained with Lean compiler feedback) on the Rosetta Stone. Enables high-throughput sampling (50–100 candidates per theorem). Analogous to AlphaGo's policy network — proposes plausible moves, doesn't need to be correct every time.

---

### 3.8 Stage 3 — Verifier and Proof Search Agent

**Role**: Compile each candidate, classify failures, repair or explore alternatives.

**Compilation**: Deterministic — calls `lake build`. Binary result: compiles or doesn't.

**On failure**:
1. Parse compiler error output.
2. Classify the error:
   - **Type mismatch** — wrong type applied to a tactic or term
   - **Missing import** — Mathlib dependency not imported
   - **Tactic failure** — tactic doesn't apply to current goal
   - **Structural error** — wrong proof structure (e.g., too few cases)
3. Attempt repair: read the error, propose a fix, recompile.
4. If repair fails after K attempts: escalate to Stage 1 (Proof Agent) for a rethinking.

**On success**: Pass verified proof to Stage 4.

**Production**: The repair component is the **RL training target**. It learns from interaction with the Lean compiler — try tactic, read error, try different tactic, get reward on success. Analogous to AlphaGo's MCTS.

**Strategy KB integration**: When the repair loop exhausts its attempts, the Verifier queries the Strategy KB for alternative approaches: "What strategies have succeeded for theorems with these mathematical objects and this error type?" This enables a more informed escalation to the Proof Agent — instead of just saying "try again," it can say "try `compactness_argument` instead of `contradiction`, it has 75% success rate for this theorem type."

**Error classification schema**:

```json
{
  "error_type": "tactic_failure",
  "error_message": "tactic 'simp' failed, no applicable lemma found",
  "lean_context": "goal: x ≿ x, hypotheses: h : x ≿ x ∨ x ≿ x",
  "attempted_fix": "replaced simp with cases h",
  "fix_result": "success"
}
```

---

### 3.9 Stage 4 — Knowledge Agent

**Role**: Integrate a verified proof into the Knowledge Tree and update all downstream resources.

**Actions**:
1. **Tag**: domain, subfield, proof strategy, complexity.
2. **Link dependencies**: which other tree nodes this proof depends on.
3. **Cross-reference Mathlib**: does an equivalent result exist? Link if so.
4. **Resolve backlog**: if this result matches a backlog entry, mark it resolved and update all downstream dependencies.
5. **Add to Rosetta Stone**: the verified (NL, Lean) pair becomes training data.
6. **Insert into Knowledge Tree**: add node + directed edges.

**Stays on Claude API permanently.** Value grows with tree size.

**Strategy tagging responsibilities** (see Section 4.4): After verification, the Knowledge Agent writes the canonical strategy tags for each proof. It records which proof strategies succeeded, which mathematical objects were involved, and which Lean tactics compiled. This feeds the Strategy Knowledge Base that other agents consult.

---

### 3.10 Resolver Agent

**Role**: Asynchronous "Tier 2" agent that works on axiomatized failures — theorems the main pipeline couldn't prove, which were accepted as axioms to keep the tree growing.

**When it runs**: After the main pipeline has completed a batch. The Resolver picks up items with status `AXIOMATIZED` and applies heavier reasoning to prove them.

**How it differs from the main pipeline**:
- Uses a heavy reasoning model (o3, Gemini extended thinking, or future equivalents) instead of the standard Claude model
- More iterations: 10 compile-repair cycles (vs 6 in the Verifier), 3 proof revisions (vs 2)
- Has access to the previous failure reason, so it doesn't repeat the same failed approach
- Combined prompt: takes a theorem statement and produces Lean 4 code directly (no intermediate structured proof for the initial attempt)

**On success**: Replaces the `axiom` declaration in `Axioms.lean` with a proved `theorem ... := by ...` in-place. The declaration name stays the same, so no downstream breakage. Updates backlog status from `AXIOMATIZED` to `COMPLETED`.

**On failure**: Restores to `AXIOMATIZED` status for future attempts with better models or more context.

**Scaling property**: As models improve, the Resolver can be re-run on the same axiomatized items. Items that were impossible for Claude today may be tractable for next-generation models. The axiom serves as a stable placeholder in the meantime.

---

## 4. Persistent Resources

### 4.1 Knowledge Tree

The central data structure. Stores:
- **Nodes**: Verified Lean proofs, each with metadata (domain, tags, source).
- **Edges**: Directed dependency relationships (theorem A depends on lemma B).
- **External links**: Cross-references to Mathlib theorems.
- **Coverage frontier**: Where formalized knowledge ends and unresolved dependencies begin.
- **Conditional nodes**: Proofs that are verified but depend on unresolved backlog items. Marked as conditional (🟡) until their dependencies are grounded.

### 4.2 Dependency Backlog

Prioritized queue of unproved claims. See Section 3.4 for full details.

Serves as both a work queue and a project dashboard. At any point shows: which results are blocking progress, where the biggest gaps are, and what the system should formalize next.

### 4.3 Rosetta Stone

Curated corpus of verified (NL proof, Lean proof) pairs. See the separate Rosetta Stone documentation for the full specification, including JSON schema, priority Mathlib modules, and generation process.

Key points:
- **Seeded from Mathlib**: ~210,000 theorems, each reverse-engineered into an NL proof sketch.
- **Grows with pipeline**: every successful run adds a pair.
- **Confidence field**: `high` (validated against a source reference), `medium` (Lean code simple enough for reliable NL reconstruction), `low` (complex proof, NL sketch may be inaccurate). Used for weighting during future model training.
- **Dual purpose**: (1) training corpus for the fine-tuned Translator model, (2) semantic search index for the Librarian (NL descriptions enable fuzzy matching between a mathematical statement and a Lean declaration).

### 4.4 Strategy Knowledge Base

A growing database of proof strategies, mathematical object patterns, and tactic effectiveness — the system's accumulated "intuition" about what works.

**Why it exists**: A human mathematician develops heuristics over years of practice — "this looks like an epsilon-delta argument," "try Zorn's lemma when you need a maximal element," "compactness + continuity usually gives you existence." The Strategy KB makes this implicit knowledge explicit and queryable, so every agent benefits from every past success and failure.

**What gets recorded** (one entry per verified proof):

```json
{
  "theorem_id": "proposition_3.D.1",
  "domain": "microeconomics",
  "mathematical_objects": ["preference_relation", "utility_function", "compact_set", "continuous_function"],
  "proof_strategies": ["direct", "compactness_argument", "extreme_value_theorem"],
  "lean_tactics_used": ["intro", "have", "exact", "apply IsCompact.exists_isMaxOn"],
  "lean_tactics_failed": ["simp", "omega"],
  "difficulty": "medium",
  "iterations_to_compile": 3,
  "proof_revisions": 0,
  "error_types_encountered": ["tactic_failure", "type_mismatch"],
  "dependencies_used": ["IsCompact.exists_isMaxOn", "ContinuousOn.comp"],
  "source": "MWG Chapter 3"
}
```

**Who writes**:
- **Knowledge Agent (Stage 4)**: After verification, writes the canonical entry — strategies, objects, tactics, difficulty.
- **Verifier (Stage 3)**: Contributes the error and repair history — which tactics failed, which fixes worked, how many iterations.

**Who reads**:
- **Proof Agent (Stage 1)**: Queries by mathematical objects. "For theorems involving `compact_set` + `continuous_function`, which strategies have the highest success rate?" → Prioritizes `compactness_argument` over `contradiction` because it compiled 80% of the time for similar theorems.
- **Translator (Stage 2)**: Queries by strategy + domain. "When the proof strategy is `cases` on order relations, what tactic patterns compiled?" → Generates Lean code using patterns that historically worked, not just generic templates.
- **Verifier (Stage 3)**: Queries when repair fails. "What alternative strategies succeeded for `type_mismatch` errors on `preference_relation` theorems?" → Suggests a different approach instead of repeating failed repairs.
- **Resolver**: Queries for hard theorems. "What strategies have been tried and failed for this theorem type?" → Avoids known dead ends.

**Queryable dimensions**:

| Query Type | Example | Used By |
|---|---|---|
| By mathematical objects | "What works for compact + continuous?" | Proof Agent |
| By proof strategy | "Show me all `contradiction` proofs in order theory" | Translator |
| By error type | "What fixes `type_mismatch` on utility functions?" | Verifier |
| By domain | "Success rate by strategy for microeconomics" | Proof Agent, pipeline dashboard |
| By tactic pattern | "Which Mathlib lemmas are used most for compactness?" | Translator, Librarian |

**Flywheel effect**: As the DB grows, the Proof Agent picks winning strategies more often on the first try → the Translator generates code that compiles more often → fewer repair iterations → lower token cost per theorem → the system can formalize more theorems per dollar → the DB grows faster. This is a direct feedback loop: every proof makes the next proof cheaper.

**Implementation**: JSON-based initially (like the backlog), queryable via Python. In production, could be backed by a vector DB for semantic queries or a simple SQLite database for structured queries. The key constraint is that reads must be fast (consulted on every formalization) while writes are infrequent (one per completed proof).

---

## 5. Training Data Flywheel

Three types of data are collected automatically:

| Data Type | Source | Contents | Future Use |
|---|---|---|---|
| **Supervised Pairs** | Successful runs | (NL proof, verified Lean code) | Fine-tune Translator (Stage 2) |
| **Failure Triples** | Failed compilations | (NL proof, bad Lean code, error type) | Improve Translator + Verifier |
| **Search Trajectories** | Repair sequences | (tactic sequence, errors, outcome) | RL training for Proof Search (Stage 3) |

Supervised pairs are simultaneously added to the Rosetta Stone.

**Flywheel dynamics**: More proofs → larger Rosetta Stone → better fine-tuned Translator → more proofs verified per attempt → faster data accumulation → repeat. Training threshold is approximately 500–1,000 verified pairs for a first fine-tuning experiment.

---

## 6. Training the Custom Models

### 6.1 Stage 2 Translator — Supervised Fine-Tuning

**Base model**: Goedel-Prover-V2-8B (Qwen3-8B base, open weights, expert-iteration trained on Lean 4 + Mathlib proofs with compiler feedback — 83% pass@32 on MiniF2F, outperforming DeepSeek-Prover-V2-671B).

**Training method**: QLoRA (quantized low-rank adaptation) — keeps base model in 4-bit precision, trains small adapter matrices.

**Hardware requirements**:
- Training: single A100 80GB (comfortable) or RTX 4090 24GB (tight). 8–15 hours on A100 for full Mathlib Rosetta Stone.
- Inference: ~6GB VRAM in 4-bit quantization. Fits on any modern GPU or Apple Silicon.
- Cloud cost estimate: $15–30 per training run. Budget $100–300 total with experimentation.

**Training data**: Rosetta Stone pairs, weighted by confidence field. High-confidence pairs weighted fully, low-confidence pairs downweighted or excluded.

### 6.2 Stage 3 Proof Search — Reinforcement Learning

**Training method**: Reinforcement learning with Lean compiler as reward signal.

**Training data**: Search trajectories — sequences of tactic attempts, errors, and outcomes.

**Analogous to**: AlphaGo's MCTS + value network training via self-play. The model learns which tactic to try given a goal state, receiving reward when the proof compiles and penalty when it doesn't.

**Naturally online**: Unlike supervised fine-tuning, RL training is inherently interactive. The model generates tactic sequences, the Lean compiler gives immediate feedback, and PPO/DPO updates can be applied after each batch of attempts. This means Stage 3 can improve continuously during pipeline operation without explicit retraining cycles.

### 6.3 Incremental Training Schedule

True online learning (update weights after every single proof) is impractical — gradient updates need batches for stability, and keeping a GPU running continuously for sporadic updates is wasteful. Instead, the system uses **periodic incremental fine-tuning**:

**Phase 1 — Base adapter** (one-time):
- Train the initial QLoRA adapter on the full Rosetta Stone (~200k Mathlib pairs + pipeline pairs accumulated so far).
- This is the expensive run: 8–15 hours on A100. Produces `adapter_v0`.

**Phase 2 — Incremental updates** (recurring):
- Trigger: every N new verified pairs (target: N = 100–500, tuned by experiment).
- Starting from the previous adapter checkpoint, train on:
  - All new pipeline pairs since last update (high weight — these are domain-specific, high-confidence)
  - A replay sample from the Rosetta Stone (prevents catastrophic forgetting of general Lean knowledge)
  - Strategy KB context injected into training examples (so the model learns strategy-conditional generation)
- Duration: ~30–60 min on A100. Produces `adapter_v1`, `adapter_v2`, etc.
- The pipeline hot-swaps to the new adapter with zero downtime.

**Phase 3 — RL refinement** (after base adapter is stable):
- Layer RL training on top of the supervised adapter.
- The Verifier's compile-repair loop becomes the training environment: generate candidate → compile → reward/penalty → update.
- Search trajectories from the Strategy KB provide offline RL data (past repair sequences with known outcomes).

**Why not true online learning?**
- Gradient updates from single examples are noisy and can destabilize the model.
- QLoRA adapters are small (~50MB) — swapping a new adapter is instant, so the latency between "new data available" and "model improved" is just the duration of one incremental training run.
- Replay buffers from the Rosetta Stone prevent the model from "forgetting" general Lean 4 in favor of overfitting to the latest domain.
- This approach gives us the benefits of online learning (model improves as data grows) with the stability of batch training.

**Training data sources and their roles**:

| Source | Size (current) | Growth Rate | Used For |
|---|---|---|---|
| Rosetta Stone (Mathlib seed) | ~200k pairs | Static (one-time) | Base adapter, replay buffer |
| Rosetta Stone (pipeline pairs) | 60 pairs | ~10-50/batch | Incremental updates (high weight) |
| Failure triples | Not yet collected | ~20-40/batch | Negative examples, error avoidance |
| Search trajectories | Not yet collected | ~5-15/batch | RL training for Stage 3 |
| Strategy KB entries | 60 entries | ~10-50/batch | Strategy-conditional training context |

---

## 7. Production Tooling

This section specifies the concrete tools, libraries, and services each component uses in production. The guiding principle: **Claude API for reasoning, local models for throughput, programmatic tools for speed.**

### 7.1 LLM Backends

**LLM Gateway — LiteLLM**: All LLM calls go through [LiteLLM](https://github.com/BerriAI/litellm), which provides a unified OpenAI-compatible interface across providers. This means agent code calls `completion(model="claude-sonnet-4-20250514", ...)` or `completion(model="deepseek-local/prover-v2", ...)` with the same API. Benefits:
- Swap models per agent without code changes (config-driven)
- Automatic retries, rate limit handling, fallback chains
- Usage tracking and cost monitoring across all providers
- The Resolver can try multiple models on the same theorem with one line of config

**Provider breakdown**:

| Provider | SDK | Models Used | Used By |
|---|---|---|---|
| Anthropic | `anthropic` Python SDK (via LiteLLM) | Claude Sonnet (primary), Claude Opus (hard reasoning) | Stages 0 (text-only), 1, 4; Librarian; Feeder |
| Local (vLLM) | OpenAI-compatible API | Goedel-Prover-V2-8B + LoRA adapters | Stage 2 (Translator), Stage 3 (repair model) |
| OpenAI | `openai` SDK (via LiteLLM) | o3, o4-mini | Resolver (rotation) |
| Google | `google-genai` SDK (via LiteLLM) | Gemini 2.5 Pro (extended thinking) | Resolver (rotation) |

### 7.2 Local Model Serving

**vLLM** for Goedel-Prover-V2-8B serving:
- Supports **LoRA adapter hot-swapping**: load `adapter_v2` while `adapter_v1` is still serving, switch with zero downtime. Critical for incremental training (Section 6.3).
- **Batched inference**: When the Translator generates 50–100 candidates per theorem, vLLM batches them efficiently on GPU. This is where local models massively beat API calls — 100 candidates via Claude API costs ~$5; via local vLLM it costs electricity.
- **Quantization**: 4-bit AWQ quantization. The 8B model fits in ~6GB VRAM, leaving room for KV cache on a 24GB card.
- Exposes an OpenAI-compatible API, so LiteLLM routes to it seamlessly.

**Hardware options**:
- Development: RTX 4090 24GB (inference + small training runs)
- Production: A100 80GB or H100 (inference + full training runs)
- Cloud: RunPod, Lambda, or Modal for on-demand GPU ($1–3/hr for A100)

### 7.3 Librarian Search Stack

The Librarian uses a layered search strategy, from fast/cheap to slow/expensive:

**Layer 1 — Declaration name index** (programmatic, instant):
- In-memory index of all Mathlib declaration names (~227k entries)
- Fuzzy string matching (Levenshtein distance, prefix search)
- Query: `"compact_exists_max"` → `IsCompact.exists_isMaxOn`
- Built from Rosetta Stone `index.json` at startup

**Layer 2 — Semantic vector search** (programmatic, ~50ms):
- Embedding index over Rosetta Stone NL descriptions
- [Chroma](https://github.com/chroma-core/chroma) (embedded, no server) or flat FAISS index
- Embedding model: `text-embedding-3-small` (OpenAI) or local `all-MiniLM-L6-v2` (free, ~80MB)
- Query: `"a continuous function on a compact set attains its maximum"` → nearest NL descriptions → their Lean declaration names
- This is where the Rosetta Stone's NL descriptions pay off as a search index

**Layer 3 — Type-based search** (Lean REPL, ~1-5s):
- [Loogle](https://loogle.lean-lang.org/) for searching Mathlib by type pattern
- Lean `exact?`/`apply?` tactics via a persistent **Lean REPL** process (avoids spawning a new `lake env lean` per query)
- Query: `"_ → IsCompact _ → ContinuousOn _ _ → ∃ _, _"` → type-matching declarations
- The REPL keeps a Lean environment loaded with Mathlib imports, so queries are fast (~1-5s vs ~30s for cold start)

**Layer 4 — LLM reasoning** (Claude API, ~5-10s):
- Only reached when layers 1-3 fail
- Claude Sonnet with the full query context: theorem statement, domain, what layers 1-3 returned
- Can reason about mathematical equivalence: "this is really the Extreme Value Theorem stated for preference relations"

**Cost impact**: In practice, layers 1-2 resolve ~60-70% of lookups instantly and for free. Layer 3 handles another ~20%. Claude is only called for the remaining ~10-20% of genuinely hard lookups.

### 7.4 Lean Compiler Interface

**Compilation**: `lake env lean` subprocess — unchanged from prototype. Lean compilation is deterministic and free.

**Lean REPL** (new for production):
- A persistent Lean 4 process with Mathlib loaded, accepting tactic queries
- Used by: Librarian (`exact?`, `apply?`), Verifier (goal-state inspection), Translator (type-checking fragments)
- Implementation: [lean4-repl](https://github.com/leanprover-community/repl) or custom via Lean's `--server` mode
- Amortizes Mathlib import time (~30s) across hundreds of queries instead of paying it per compilation

### 7.5 Storage Progression

| Phase | Backend | Components Stored | When |
|---|---|---|---|
| Prototype (now) | JSON files | Backlog, training data, strategy KB, extractions | Current |
| Near-term | SQLite | Backlog, strategy KB, knowledge tree | When query patterns stabilize |
| Production | PostgreSQL + pgvector | All structured data + semantic embeddings | When we need concurrent access or scale beyond single machine |

SQLite is the sweet spot for most of the project's life — single file, ACID, queryable, zero configuration. PostgreSQL is only needed if we run multiple pipeline instances concurrently or need the Librarian's vector search tightly integrated with structured queries.

### 7.6 Orchestration

Custom async Python — not a framework. The pipeline flow is well-defined (extract → route → prove → translate → verify → integrate), not dynamically routed. Frameworks like LangGraph or CrewAI add abstraction overhead without clear benefit for a fixed pipeline.

Key components:
- `asyncio` for concurrent agent calls within a stage (e.g., multiple Translator candidates in parallel)
- `httpx` for async LLM API calls (via LiteLLM's async interface)
- Simple retry/backoff logic (already built)
- Structured logging with per-theorem trace IDs for debugging

### 7.7 Cost Model

The production tooling is designed to minimize per-theorem cost:

| Component | Prototype Cost | Production Cost | Savings |
|---|---|---|---|
| Stage 0 (Extraction) | ~$0.10/page (Claude Code) | ~$0.01/page (Marker pre-conversion + Sonnet API text-only) | 90% |
| Stage 1 (Proof Agent) | ~$0.15/theorem | ~$0.05/theorem (Sonnet API) | 67% |
| Stage 2 (Translator) | ~$0.30/theorem (1 candidate) | ~$0.002/theorem (100 candidates, local vLLM) | 99% |
| Stage 3 (Verifier) | ~$0.20/theorem (6 repair iterations) | ~$0.01/theorem (local repair model + free compilation) | 95% |
| Stage 4 (Knowledge Agent) | ~$0.10/theorem | ~$0.03/theorem (Sonnet API) | 70% |
| Librarian | ~$0.05/lookup | ~$0.005/lookup (programmatic 80%, Claude 20%) | 90% |
| **Total per theorem** | **~$1.00** | **~$0.12** | **~88%** |

At $0.12/theorem, formalizing all of MWG (~2,000 theorems) costs ~$240. The entire Rudin or Munkres could follow for similar cost. The fine-tuning investment (~$30-100) pays for itself after ~300 theorems.

---

## 8. Project Structure

```
LeanKnowledge/
├── pyproject.toml
├── README.md
├── ARCHITECTURE.md                         # This file
├── CLAUDE.md                               # Developer instructions for Claude Code
├── lakefile.toml                           # Lean 4 Lake project config
├── lean-toolchain                          # Lean version pin
├── leanknowledge_architecture.mermaid      # Visual architecture diagram
├── src/
│   └── leanknowledge/
│       ├── __init__.py
│       ├── pipeline.py                     # Orchestrator: chains stages + CLI entrypoints
│       ├── router.py                       # Claim routing logic
│       ├── claude_client.py                # Claude CLI wrapper (claude -p)
│       ├── deepseek_client.py              # DeepSeek-Prover-V2 backend
│       ├── embedding_index.py              # Sentence-transformer vector search
│       ├── librarian_index.py              # BM25 search index
│       ├── schemas.py                      # Pydantic models for claims, proofs, etc.
│       ├── backlog.py                      # Dependency backlog operations
│       ├── agents/
│       │   ├── extraction.py               # Stage 0: PDF → ExtractedItem objects
│       │   ├── librarian.py                # Mathlib/Knowledge Tree lookup (3-tier RAG)
│       │   ├── proof.py                    # Stage 1: raw proof → structured NL proof
│       │   ├── translator.py               # Stage 2: NL → Lean 4 code
│       │   ├── verifier.py                 # Stage 3: compile + repair loop
│       │   ├── knowledge.py                # Stage 4: deterministic tagging + integration
│       │   └── resolver.py                 # Tier 2: heavy-model proof of axiomatized failures
│       └── lean/
│           ├── compiler.py                 # Lean 4 compiler interface (lake env lean)
│           ├── errors.py                   # Error parsing + classification
│           └── repair_db.py                # 3-tier deterministic repair patterns
├── prompts/                                # Prompt templates for each agent
│   ├── extraction_agent.md
│   ├── proof_agent.md
│   ├── lean_translation.md
│   ├── axiom_translation.md
│   ├── knowledge_agent.md
│   ├── librarian.md
│   ├── resolver.md
│   └── rosetta_stone.md
├── rosetta_stone/                          # Training corpus
│   ├── pairs/                              # (NL, Lean) pairs — one JSON per Mathlib source
│   │   ├── index.json                      # Master index (222k pairs)
│   │   └── Mathlib.*.json                  # ~7,179 files covering all of Mathlib
│   └── generate.py                         # NL generation from Lean source
├── scripts/
│   └── run_mwg_batch.py                    # MWG chapter batch runner
├── citation_graph/                         # Economics paper citation network
│   ├── build_graph.py                      # Semantic Scholar graph builder
│   ├── build_graph_openalex.py             # OpenAlex alternative backend
│   └── ...                                 # Merge, mapping, and query scripts
├── LeanProject/                            # Lean 4 project with Mathlib
│   ├── Scratch.lean                        # Temp compilation target (auto-generated)
│   └── *.lean                              # Verified proofs
├── Sources/                                # Source PDFs (gitignored)
├── outputs/                                # Verified .lean files + extraction JSONs
│   └── extractions/                        # Raw extraction results
├── training_data/                          # Auto-saved (NL, Lean) pairs
├── .github/workflows/                      # CI/CD
│   ├── lean_action_ci.yml                  # Lean compilation check
│   ├── create-release.yml                  # Auto-tag on toolchain change
│   └── update.yml                          # Daily Mathlib update check
├── backlog.json                            # Persistent work queue (gitignored)
└── librarian_index.json                    # BM25 search index (gitignored)
```

**Not yet implemented** (designed in this document but not built):
- `agents/feeder.py` — Backlog → source procurement (Section 3.5)
- `strategy_kb.py` / `strategy_kb.json` — Strategy Knowledge Base (Section 4.4)
- Fine-tuning trainer scripts (Section 6)

---

## 9. Current Status

*Last updated: February 2026*

### Built and Operational

- **All 8 agents implemented**: Extraction, Proof, Translator, Verifier, Knowledge, Librarian, Resolver, Router. All run via Claude Code CLI (`claude -p`). DeepSeek API and Goedel-Prover-V2-8B available as alternative backends. Stage 0 (Extraction) uses Marker-based markdown input (text-only, no vision needed).
- **Knowledge Agent**: Fully deterministic — regex-based tagging with 60-entry tactic map, no LLM calls.
- **RepairDB**: 3-tier deterministic repair (Tier A: ~35% exact pattern match, Tier B: ~25% heuristic, Tier C: ~40% LLM fallback). Significantly reduces API cost per theorem.
- **Librarian**: 3-tier RAG search — sentence-transformer embeddings (threshold ≥ 0.85 auto-match), BM25 keyword search, Claude Haiku verification for borderline cases. 42MB index built from Rosetta Stone + pipeline pairs.
- **Backlog system**: Persistent JSON queue with dependency-aware scheduling. Status flow: PENDING → BLOCKED → READY → IN_PROGRESS → COMPLETED/FAILED/AXIOMATIZED/SKIPPED.
- **Citation graph**: Economics paper network built via Semantic Scholar + OpenAlex (10 scripts in `citation_graph/`). Separate from main pipeline, used for paper sourcing.

### Data Assets

- **Rosetta Stone**: **Complete.** 7,179 files, 221,853 indexed NL-Lean pairs covering all of Mathlib. ~57% generated mechanically (no LLM calls), ~43% via Claude. Master index at `rosetta_stone/pairs/index.json`.
- **MWG Textbook**: Chapters 1–23 extracted (36 batches, ~500 backlog entries). ~69 completed, ~50 ready, 5 failed, 2 axiomatized.
- **Pipeline training pairs**: ~60 verified (NL proof, Lean code) pairs saved automatically from pipeline runs.

### Recently Built (Phase 2)

- **Feeder Agent**: Implemented (`agents/feeder.py`) with citation graph suggestions. Integrated into pipeline via `feed_blocked()`.
- **Strategy Knowledge Base**: Wired into ProofAgent (strategy hints), Translator (tactic hints), and Verifier (tactic hints on re-translation). Strategy success rates inform proof generation.
- **LiteLLM gateway**: Opt-in via `LK_USE_GATEWAY=1` (`llm_gateway.py`). Routes calls to Anthropic, DeepSeek, or local vLLM.
- **Lean REPL**: Implemented (`lean/repl.py`) with cached `lake env printPaths --json`. Reduces per-compilation overhead.
- **SQLite migration**: Dual-write (JSON + SQLite) via `leanknowledge migrate`. Incremental single-entry writes for Backlog and Strategy KB.
- **Fine-tuning pipeline**: QLoRA trainer (`training/train_translator.py`) targeting Goedel-Prover-V2-8B. Data preparation, SLURM scripts, eval harness, and DPO repair stub all ready. Not yet executed.
- **Triage tooling**: `scripts/triage_backlog.py` resets stuck IN_PROGRESS and FAILED items.

### Not Yet Built

- **Full Librarian search stack**: Loogle API integration built (`loogle_client.py`, Layer 3). Still missing `exact?`/`apply?` via Lean REPL (Layer 3b of Section 7.3). Current implementation covers Layers 1-3 plus Claude fallback.
- **RL training for Stage 3**: Designed (Section 6.2), stub written (`training/train_repair.py`). Needs search trajectory collection and fine-tuned base model first.
- **Failure triples / search trajectories**: Collection code implemented in pipeline.py and verifier.py, but not yet tested in production runs.

---

## 10. Design Principles

1. **Never chase dependencies.** Classify and shelve. The backlog exists so the pipeline never recurses.
2. **Never reprove what already exists.** The Librarian checks Mathlib and the Knowledge Tree before any formalization begins. This becomes increasingly critical as the tree and backlog grow — the "meeting in the middle" between bottom-up textbook work and top-down paper work depends on recognizing when a result is already available.
3. **Every run produces training data.** Success or failure, something is learned.
4. **Agents have one job.** The Reader extracts, the Librarian finds existing results, the Feeder procures source material, the Proof Agent structures, the Translator converts, the Verifier checks, the Knowledge Agent organizes. No agent does two things.
5. **The system improves with use.** The flywheel is not aspirational — it is the architecture. The Rosetta Stone grows, the tree grows, the backlog shrinks, the Strategy KB accumulates heuristics, and the fine-tuned models periodically retrain on the growing corpus.
6. **Proofs are honest about their foundations.** Conditional verification is tracked explicitly. A proof that depends on unresolved claims is marked as such.
7. **Start simple, specialize later.** Claude Code handles everything now. Fine-tuning and RL come when the data justifies them.

---

## 11. Future Enhancements

### 11.1 Loogle Integration (Librarian Layer 3)

[Loogle](https://loogle.lean-lang.org/) is a type-based search engine for Lean 4 / Mathlib, developed by the Lean FRO. It has a JSON API (`loogle.lean-lang.org/json?q=QUERY`) returning declaration names, modules, type signatures, and documentation. This fills the Librarian's Layer 3 gap (Section 7.3) — type-based search that neither embedding similarity nor BM25 keyword matching can handle well. Example: querying `IsCompact _ → ContinuousOn _ _ → ∃ _` finds `IsCompact.exists_isMaxOn` directly by type shape.

**Integration**: `src/leanknowledge/loogle_client.py` wrapping the API, called by the Librarian between Layers 2 and 4. Zero LLM cost. Rate-limited by the hosted service; for production, the Lean REPL with `exact?`/`apply?` serves as a local fallback.

### 11.2 Mathlib references.bib for the Feeder

Mathlib's `docs/references.bib` (423 entries, at `.lake/packages/mathlib/docs/references.bib`) catalogs the textbooks and papers that Mathlib contributors cited when formalizing results — Rudin, Munkres, Bourbaki, etc. The Feeder can cross-reference this with the Rosetta Stone: if a Mathlib declaration cites Rudin Chapter 4, and a backlog item is the same theorem stated differently, the Feeder knows which source to consult.

**Integration path**: Parse references.bib into a searchable index (title, author, bibkey). Cross-reference with Rosetta Stone declarations that use `## References` docstrings. When the Feeder resolves an `unreferenced` backlog item, query the bib index for topic matches → identifies which textbook to Marker-convert and feed to Stage 0. The bib file is heavily skewed toward pure math; economics sources (MWG, Milgrom & Shannon) would be added as we formalize those domains.

### 11.3 Monitoring Dashboard

A Streamlit web app reading from backlog.json, strategy_kb.json, and training_data/ to provide:

- **Backlog view**: Sortable table with status breakdown charts, top blockers by priority score, resolution timeline
- **Knowledge tree visualization**: Interactive graph (NetworkX + Plotly) showing theorem nodes colored by status (verified/conditional/axiomatized), dependency edges, search/zoom, coverage frontier
- **Metrics dashboard**: Theorems verified per batch, average compile iterations, success rate by stage, token cost per theorem, flywheel metrics (Rosetta Stone growth, backlog shrinkage, Strategy KB hit rates)
- **Strategy KB insights**: Queryable interface for mathematical objects → ranked strategies with success rates

Build when the project reaches ~200+ verified theorems and needs multi-domain prioritization. Until then, `leanknowledge status` suffices.
