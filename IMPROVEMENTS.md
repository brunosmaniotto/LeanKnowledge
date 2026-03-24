# LeanKnowledge — Improvements & Run Analysis

## Current Status (post-Run 8)

### Run 7 results (final)

- **1,000 theorems**, 864/896 attempted = **96.4%** success rate
- All tiers: Gemini 2.5 Pro via Vertex AI
- 104 rerouted (skipped), 32 genuine failures
- Cost: ~$107

### Run 8 results (final)

- **1,000 NEW theorems** (disjoint from Run 7), 571/1000 = **57.1%** success rate
- DeepSeek Reasoner (Direct + Tier 1) + Gemini 2.5 Pro (Tier 2)
- 20 parallel workers, 16-attempt budget
- Cost: ~$50

### Key insight: Run 7 vs Run 8

Run 7 was all-Gemini (96.4%), Run 8 used DeepSeek + Gemini tiered (57.1%). But the
theorem sets are completely disjoint — Run 8 drew harder categories. The comparison
is **not apples-to-apples**.

### Error taxonomy (572 failures across both runs)

| Error category | Count | % | Notes |
|---|---|---|---|
| Parse errors | 161 | 28% | `unexpected token 'in'`, Lean 3/4 syntax confusion |
| Hallucinated identifiers | 136 | 24% | Models invent Mathlib lemma names |
| Function expected (namespace) | 65 | 11% | Missing `open` statements |
| Unsolved goals | 57 | 10% | Right structure, wrong tactic |
| Other | 47 | 8% | Miscellaneous |
| Typeclass synthesis failed | 30 | 5% | |
| Type mismatch | 27 | 5% | Wrong types or coercions |
| Empty output | 21 | 4% | Model returns no code |

### Category performance (Run 8)

| Category | Success rate |
|---|---|
| Group Theory | 90.4% |
| Set Theory | 89.7% |
| Relations | 84.1% |
| Logic | 83.8% |
| ... | ... |
| Trigonometry/Geometry | 41.1% |
| Probability | 26.1% |

---

## Next Improvements

### 1. Fix parse errors (~28% of failures)

**Problem**: The single largest failure category. Models produce Lean 3 syntax or
get tripped up on notation like `\sum i \in` vs `\sum i in` (the Finset binder
syntax is a common trap).

**Fix**: Better prompt engineering for Lean 4 syntax — add explicit "common mistakes"
section to the translator prompt with before/after examples of the most frequent
parse errors. Consider a deterministic syntax-repair pass in `repair_db.py` for
the most mechanical patterns (e.g., replacing `∑ i ∈ s,` with `∑ i in s,`).

### 2. Auto-inject `open` statements for namespace errors (~11% of failures)

**Problem**: 65 failures are "function expected" errors caused by models using
qualified names like `Finset.sum` without opening the namespace, or vice versa.

**Fix**: When the compiler returns a "function expected" or "unknown identifier"
error and the identifier contains a `.`, auto-inject `open <Namespace>` at the
top of the file and retry. This is a deterministic fix that belongs in `repair_db.py`
or as a pre-compilation transform.

### 3. Empty output retry with fallback model (~4% of failures)

**Problem**: 21 cases where the model returns no usable Lean code. Usually
DeepSeek spending its entire output budget on `<think>` reasoning.

**Fix**: When a tier produces empty output, don't count it as a real attempt —
retry with the same model once (already partially done), then fall back to the
next tier's model immediately rather than burning remaining attempts.

### 4. Coercion insertion for type mismatches (~5% of failures)

**Problem**: 27 failures from type mismatches, often involving `Nat` vs `Int` vs
`Real` coercions that Lean doesn't insert automatically.

**Fix**: Parse the type mismatch error ("expected `Real`, got `Nat`") and inject
appropriate coercion casts (`(↑n : Real)`) into the error-driven retry prompt.
Could also add common coercion patterns to the translator prompt.

### 5. Category-specific prompt tuning

**Problem**: Performance varies wildly by category (Group Theory 90% vs
Probability 26%). One-size-fits-all prompting doesn't work.

**Fix**: Detect the mathematical domain from the claim metadata and load
domain-specific prompt supplements with relevant Mathlib imports, notation
conventions, and worked examples. Priority: probability (measure theory imports),
trigonometry (Real.sin/cos API), geometry (EuclideanGeometry namespace).

### 6. Scale to full ProofWiki corpus

**Problem**: We've proven ~1,435 of 17,911 ProofWiki theorems across two runs.

**Fix**: Run the full corpus with the improvements above. Target: 10,000+
verified proofs. This provides the training data for item 7.

### 7. RL fine-tuning on verified triples

**Problem**: We now have 1,435 verified (NL proof, Lean 4 code, compiler output)
triples — enough for a meaningful fine-tuning run.

**Fix**: Retrain Goedel-Prover on the collected triples. Use the verified proofs
as positive examples and the failed attempts as negative examples (DPO/RLHF).
Reintroduce as Tier 0 (fastest, cheapest) when the fine-tuned model demonstrates
>50% success rate on a held-out test set.

---

## Historical: Post-Run 4 Improvements (all completed)

Based on analysis of Run 4 data (101 triples, 91 failures, 10 successes).

### Failure diagnosis (Run 4)

| Error category | Count | % | Root cause |
|---|---|---|---|
| Mathlib API issues | ~50 | 54% | Model hallucinates identifiers |
| Empty/vacuous output | 18 | 19% | DeepSeek reasoning consumes output budget |
| Syntax errors | 12 | 13% | Lean 3/4 confusion, bad token placement |
| Unsolved goals | 5 | 5% | Right structure, wrong tactic |
| Type mismatch | 4 | 4% | Wrong types or calling conventions |
| Build cache errors | 2 | 2% | Transient Lean build issues |

Model performance: Goedel 0/30, DeepSeek 9/55, Sonnet 1/6.

---

### 1. Mathlib hint injection (addresses 54% of failures)

**Problem**: Models hallucinate identifiers (`Nat.factors`, `RiemannZeta`, `Real.deriv_sin`).

**Fix**: Before translation, search the Rosetta Stone corpus for relevant Mathlib
lemmas and inject their names + signatures into the prompt.

- Search by: theorem statement + NL proof text → embedding similarity against 222K Rosetta Stone pairs
- Return: top 10-15 Mathlib declarations with full type signatures
- Inject into: both direct and guided system prompts as a "Mathlib cheat sheet"
- **Where it lives**: `MathlibIndex` in `mathlib_index.py` with TF-IDF search, injected via
  `_get_mathlib_hints()` in Agent 6's `_try_tier()`. Also: `PromptTuner` tracks confirmed
  identifiers from successful proofs and injects them into subsequent prompts.
- **Status**: DONE (2026-03-09) — TF-IDF index + RAG injection + cross-theorem identifier learning

### 2. Pass the NL proof into guided mode

**Problem**: When direct fails and we escalate to guided, the translator sees
Agent 5's JSON but **not the original NL proof**. The raw NL proof is strictly
more informative than the restructured JSON.

**Fix**: Thread `ExtractedItem` through to `translate()` and append `item.proof`
to `_build_initial_prompt` / `_build_retry_prompt` alongside the StructuredProof.

- Zero cost, no new infrastructure
- **Status**: DONE (2026-03-08)

### 3. Fix DeepSeek empty output (19% of failures)

**Problem**: 18 of 91 failures are DeepSeek returning empty/vacuous output. Likely
causes: `<think>` blocks consuming the output budget, or `_extract_lean_code`
failing to parse reasoning-heavy responses.

**Fix**: Investigate and fix. Options:
- Increase `max_tokens` for DeepSeek
- Add extraction pass that looks inside `<think>` tags
- Add a "code not found" retry before counting as a real attempt
- **Status**: DONE (2026-03-08) — `_extract_lean_code` strips `<think>` blocks

### 4. Simplify Agent 5's role

**Problem**: Agent 5 spends an expensive LLM call producing a 50-line JSON plan
that models mostly ignore. Winning proofs are short Mathlib calls, not step-by-step.

**Fix**: Removed Agent 5 from the pipeline entirely. The guided phase now goes
straight to `translate_unstructured()` which passes the NL proof through without
a structured plan. Agent 5 code kept intact for future use if needed.

- **Status**: DONE (2026-03-10) — Agent 5 skipped in pipeline.py

### 5. Cross-theorem learning within a run

**Problem**: Theorem 15 doesn't benefit from proving theorems 2-14.

**Fix**: After each success, parse the compiled Lean file for Mathlib identifiers
used. Maintain a "recently useful lemmas" list injected into subsequent prompts.

- Example: after Law of Cosines uses `Real.cos_sq_add_sin_sq`, De Moivre gets
  that lemma suggested automatically
- Lightweight — string matching on successful Lean files, no embeddings needed
- **Status**: DONE (2026-03-09) — `PromptTuner` extracts identifiers from compiled code,
  injects top-N confirmed identifiers into subsequent prompts. `save_identifiers()` /
  `load_identifiers()` persist across runs.

### 6. Goedel adapter — keep but improve

**Problem**: 0 wins across all runs (30 failures in Run 4 alone). Tier 1 is
currently pure overhead.

**Decision**: Remove Goedel from the pipeline loop entirely. 0 successes across
all runs — it wastes time and requires the GPU VM ($0.70/hr). Instead:
- Run all attempts via cloud APIs (DeepSeek + Sonnet) — 84% cheaper infrastructure
- Collect triples from scale runs on ProofWiki (target: 500+ successes)
- Retrain Goedel on actual NL→Lean triples (not Rosetta Stone Lean→NL pairs)
- Reintroduce as Tier 1 when retrained model demonstrates non-zero success rate

**Status**: DONE (2026-03-08) — Goedel removed from loop, GPU VM no longer needed

### 7. Hard theorem path (3rd escalation tier)

**Problem**: Some theorems (FTA, De Moivre, Basel) are genuinely hard — no single
Mathlib shortcut exists. Monolithic translation fails after 15 attempts.

**Fix**: Add a 3rd tier after Tier 2 exhausts. The full escalation becomes:

```
Phase 1 — Direct:    3× DeepSeek  (attempts 1-3)
Phase 2 — Guided:
  Tier 1:            7× DeepSeek  (attempts 4-10)
  Tier 2:            5× Sonnet    (attempts 11-15)
  Tier 3 (hard):     Decompose into sub-lemmas, prove each independently
```

Tier 3 design:
- A decomposer model breaks the theorem into independent sub-lemmas
  with typed Lean interfaces
- Each sub-lemma is proven independently (3× DeepSeek per sub-lemma)
- Partial success generates training data (positive triples for solved steps)
- Sub-lemmas are composable / reusable across theorems

This mirrors how mathematicians work: try the quick approach first, then
systematic approaches, then break it into pieces.

**Status**: DONE (2026-03-08) — `_try_decomposed()` in translator.py, prompt in `prompts/decomposer.md`

---

### Historical implementation order

| Priority | Item | Effort | Expected impact |
|----------|------|--------|-----------------|
| **Done** | #2 — Pass NL proof to guided mode | 30 min | Moderate (free information) |
| **Done** | #3 — Fix DeepSeek empty output | 1-2 hrs | Eliminates 19% of failures |
| **Done** | #5 — Cross-theorem learning | Half day | Moderate (compounds over run) |
| **Done** | #4 — Simplify Agent 5 | Half day | Moderate (cheaper, less constraining) |
| **Done** | #1 — Mathlib hint injection | 1-2 days | High (addresses 54% of failures) |
| **Done** | #7 — Hard theorem path | 2-3 days | High for hard theorems only |
| **Done** | #6 — Remove Goedel, retrain later | 30 min | 84% infra savings, 3.4× more theorems/$250 |

---

## Tracking

| Date | Change | Result |
|------|--------|--------|
| 2026-03-08 | Plan created from Run 4 analysis | — |
| 2026-03-08 | #2 NL proof passthrough implemented | Guided prompts now include original NL proof |
| 2026-03-08 | #3 DeepSeek `<think>` block stripping | `_extract_lean_code` strips `<think>` blocks before parsing |
| 2026-03-08 | #7 Tier 3 decomposition implemented | Full pipeline: decomposer → sub-lemma prover → assembly. 186 tests pass |
| 2026-03-08 | #6 Goedel removed from pipeline | Cloud-only (DeepSeek + Sonnet). GPU VM no longer needed. 15 max attempts (was 18) |
| 2026-03-11 | Run 8 improvements deployed | Tier restructure, worker robustness, warm cache, 16-attempt budget |
| 2026-03-16 | Post-Run 8 analysis added | Error taxonomy from 572 failures, next improvement plan |
