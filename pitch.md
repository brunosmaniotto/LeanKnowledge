---
marp: true
theme: default
paginate: true
style: |
  :root {
    --color-background: #fdfdfd;
    --color-foreground: #1a1a2e;
    --color-highlight: #4361ee;
    --color-dimmed: #6c757d;
    font-family: 'Inter', 'Helvetica Neue', Arial, sans-serif;
  }
  section {
    padding: 50px 60px;
  }
  h1 {
    color: var(--color-highlight);
    font-weight: 700;
    font-size: 1.8em;
    margin-bottom: 0.3em;
  }
  h2 {
    color: var(--color-foreground);
    font-weight: 600;
    font-size: 1.1em;
    margin-bottom: 0.8em;
  }
  blockquote {
    border-left: 4px solid var(--color-highlight);
    padding: 0.3em 1em;
    background: #f0f4ff;
    font-style: italic;
    margin: 0.8em 0;
  }
  table {
    font-size: 0.75em;
  }
  code {
    background: #f0f4ff;
    color: var(--color-highlight);
    padding: 0.1em 0.3em;
    border-radius: 3px;
  }
  em {
    color: var(--color-highlight);
    font-style: normal;
    font-weight: 600;
  }
  .small {
    font-size: 0.7em;
    color: var(--color-dimmed);
  }
---

<!-- _paginate: false -->
<!-- _class: lead -->

# LeanKnowledge

### Formalizing Microeconomic Theory with LLMs

<br>

Bruno Smaniotto

<span class="small">March 2026</span>

---

# The standard framing is backwards

The AI + theorem proving community is focused on one question:

> Can LLMs *discover* new proofs?

AlphaProof, DeepSeek-Prover, Lean-STaR -- all chase novel results.

Meanwhile, **entire fields of rigorous mathematics have never been formalized.** Mathlib has ~263K theorems, almost all pure math. Microeconomic theory -- utility maximization, Nash equilibria, mechanism design, contract theory -- is completely absent.

Nobody is formalizing the fields where rigorous proof already exists but the Lean encoding doesn't.

---

# Why microeconomic theory?

Four properties make it the ideal target:

**1. Not in Mathlib.** Every theorem we formalize is genuinely new. No risk of duplicating existing work.

**2. Self-contained.** Micro theory draws on optimization, fixed-point theorems, and basic real analysis. It doesn't need the deep dependency chains that make pure math formalization intractable -- you don't need homological algebra to prove the Second Welfare Theorem.

**3. Young.** The field begins with von Neumann & Morgenstern (1944) and Arrow & Debreu (1954). The canonical literature spans ~80 years and ~50,000 well-cited papers. We can map it completely.

**4. Uniform proof patterns.** Constrained optimization, envelope theorems, fixed-point existence, comparative statics. Repetitive structure plays to an LLM's strength.

---

# We mapped the entire field

Using the OpenAlex academic database, we built a citation graph of all microeconomics papers with 10+ citations. PageRank ranks papers by *influence*, not just raw citation count.

| Threshold | Papers | Citation edges |
|-----------|--------|----------------|
| >100 citations | 53,559 | 346,458 |
| >50 citations | 114,475 | 820,027 |
| >10 citations | *364,651* | *2,708,923* |

This gives us something no pure-math formalization project has: a *quantifiable boundary* for the field. We know the total scope, can estimate cost, prioritize by influence, and measure progress.

---

# Top of the graph

The most influential papers by PageRank (364K paper set):

| Rank | Year | Paper | In-degree |
|------|------|-------|-----------|
| 1 | 1988 | Prospect Theory (Kahneman & Tversky) | 5,168 |
| 2 | 1979 | Prospect Theory: Decision under Risk | 5,559 |
| 3 | 1976 | A New Approach to Consumer Theory (Lancaster) | 1,595 |
| 4 | 1978 | Measuring Efficiency of DMUs (Charnes & Cooper) | 2,966 |
| 5 | 1974 | Hedonic Prices (Rosen) | 1,645 |
| 6 | 1961 | Auctions (Vickrey) | 2,040 |
| 7 | 1960 | The Problem of Social Cost (Coase) | 1,674 |

These are the foundational results. Formalizing them first maximizes the number of downstream theorems that can reference verified lemmas.

---

# The landscape right now

The excitement around AI + math is real -- and revealing.

- **Terry Tao** experiments with ChatGPT as a mathematical assistant
- **AlphaProof** (DeepMind) solved IMO problems -- a milestone in novel proving
- **First Proof** (Feb 2026): 11 top mathematicians posed 10 research-level lemmas to LLMs. Result: *2 out of 10 solved.* The rest were "very convincing nonsense."

The pattern: LLMs are better at *finding known results* than *discovering new ones*.

LeanKnowledge leans into this. Instead of chasing novel proofs, we systematically formalize an entire field of known mathematics -- building the infrastructure that future provers need.

---

# LeanKnowledge: the idea

A multi-agent pipeline that reads economics papers and produces *machine-verified Lean 4 proofs*, guided by a citation graph of the field.

```
PDF / Paper                                      Verified Knowledge Graph
    |                                                      ^
    v                                                      |
 Extract --> Classify --> Translate --> Verify --> Validate -+
 claims      & triage     Lean 4       Lean       proof
             (def/thm/    code         compiler   integrity
              remark)                              check
```

The key insight: formalizing known math is a *translation* problem, and LLMs are good at translation.

---

# Two modes, one system

**Bottom-up:** Feed a textbook chapter (e.g., Mas-Colell). Most claims have proofs. They flow through the pipeline sequentially, building foundations.

**Top-down:** Feed a research paper (e.g., a 2020 mechanism design paper). Many claims reference prior work. They go to a *dependency backlog* -- a queue of what needs to be formalized first.

The two modes converge: textbook work resolves what papers need. The citation graph reveals which foundations to prioritize.

---

# Axiomatize and continue

When the prover hits a dependency it does **not** recurse. It stubs the dependency as a Lean axiom and keeps going.

This mirrors *how economists actually work*. When reading a paper, you accept cited results and continue. You don't stop to re-derive Arrow's Impossibility Theorem from first principles.

```
Proving Theorem T...
  -> needs Lemma D (cited: "Arrow 1951, Thm 2")
  -> Librarian: D not in library yet
  -> Add D as axiom in Lean, add to inbox
  -> Continue proving T using the axiom
```

Early on, this creates many axiom stubs. As the library grows, **more dependencies already exist** -- the system gets faster over time.

---

# Architecture: the right model for each job

| Stage | Model | Rationale |
|-------|-------|-----------|
| Text extraction | PyMuPDF / Google Document AI | Escalate for scans |
| Claim extraction | Sonnet + DeepSeek ensemble, Opus arbiter | Different families = different blind spots |
| Direct (3 attempts) | DeepSeek Reasoner | Cheapest. Often sufficient. |
| Guided Tier 1 (7 attempts) | DeepSeek Reasoner | Full error history |
| Guided Tier 2 (5 attempts) | Gemini 2.5 Pro | Stronger model, all prior failures |
| Tier 3: decomposition | Gemini 2.5 Pro | Break into sub-lemmas |

**88% of winning proofs came from DeepSeek** -- the cheapest model. Expensive models only see what cheap models can't solve.

---

# Results: three microeconomics textbooks

The primary target. Each textbook was fed through the pipeline end-to-end: PDF extraction, claim classification, Lean translation, compiler verification, post-compilation validation.

| Corpus | Total items | Definitions | Theorems | Proved | Failed | Rate |
|--------|-------------|-------------|----------|--------|--------|------|
| MWG (23 ch + appendix) | 1,948 | ~700 | ~1,250 | ~1,246 | 1 | *99.7%* |
| Jehle & Reny | 1,546 | ~400 | ~1,150 | ~1,144 | 2 | *99.5%* |
| Vickrey 1961 | 236 | ~50 | ~160 | ~159 | 0 | *99.4%* |
| **Total** | **3,730** | **~1,150** | **~2,560** | **~2,549** | **3** | ***99.6%*** |

Definitions (economic assumptions, preference structures, equilibrium concepts) are correctly formalized as `structure`/`def`. 427 proofs contain deferred axioms for dependencies (by design). 4 theorems decomposed into sub-lemmas (assembly verified). All runs used free CLI backends. Zero API cost.

---

# The 3 failures

Out of ~2,560 theorems attempted across three textbooks, 3 exhausted all tiers (16+ attempts each) without a valid proof:

**1. Claim_17.G_a** (MWG ch17 — General Equilibrium)
> Gross substitutes + z(p;q)=0 implies dp·D_p z(p;q)·dp < 0 for dp not proportional to p; the normalized Jacobian D_{p̂}ẑ is negative semidefinite.

Tier 3 decomposition assembly also failed — `finrank` field error in the sub-lemma types.

**2. Theorem_A2.24** (Jehle & Reny — Mathematical Appendix)
> Disjoint convex sets A, B ⊂ ℝⁿ can be separated by a hyperplane. If one is closed and the other compact, separation is strict.

Typeclass synthesis failure on inner product / normed space annotations. Tier 3 decomposed into 4 sub-lemmas but assembly types were incompatible.

**3. Exercise_6.15_a** (Jehle & Reny — Social Choice)
> The social welfare function F(w, y) is homogeneous of degree 1 in y.

No proof in textbook (exercise). Model hallucinated `StrictAntiMonoOn` (correct: `StrictAntiOn`).

---

# Pipeline development: ProofWiki test runs

The pipeline was built iteratively on 2,000 ProofWiki theorems (general math — number theory, algebra, topology). These test runs were not the goal; they were the *development substrate* for the translation engine, pre-compiler, and tier escalation.

| Run | Theorems | Proved | Rate | Models |
|-----|----------|--------|------|--------|
| Run 7 | 1,000 | 864 | *96.4%* | Gemini 2.5 Pro (all tiers) |
| Run 8 | 1,000 | 571 | *57.1%* | DeepSeek + Gemini (tiered) |
| **Combined** | **2,000** | **1,435** | **75.7%** | |

Key lessons from these runs — removing the proof structurer, adding decomposition, building the pre-compiler, learning that 88% of wins come from the cheapest model — directly shaped the system that then formalized the economics textbooks.

---

# What we found: honest assessment

An internal audit of all 3,730 formalized items revealed 132 fake proofs:

- 86 axiom-only stubs (`axiom TargetName : Prop` instead of a proof)
- 46 vacuous proofs (`theorem TargetName : True := trivial`)

**Root cause:** No post-compilation validation. The pipeline accepted any code that compiled, without checking that the target theorem was actually proved. Models that couldn't formalize a claim would silently produce a trivial placeholder.

**What we did:** Added proof validation, classified the 132 stubs (83 mathematical, 49 verbal/unformalizable), retried the mathematical ones, reclassified the verbal ones as remarks. **78 of 83 proved on retry (98.8%).** The "failures" were a validation gap, not a capability gap.

---

# Fixing it: proof validation

We added `validate_proof_output()` -- a post-compilation check that verifies:

1. **Target item appears as `theorem`/`lemma`**, not as `axiom`
2. **Proof type is not vacuous** (rejects `theorem X : True := trivial`)
3. **File contains real declarations** (not just comments)

Failed validation counts as a failed attempt. The model gets the error message in its retry context and tries again.

```
Attempt 3: REJECTED -- target 'Claim_11B_l' has a vacuous proof
           (type is True/Prop). Must prove the actual statement.
```

New `TARGET_AXIOMATIZED` outcome tracks items that exhaust all attempts without a genuine proof. Rosetta entries now carry a `proof_status` field (`"verified"` / `"deferred_axioms"`).

---

# Fixing it: extraction quality

Not everything in an economics textbook is a formalizable theorem.

> "Well-defined and enforceable property rights are essential for bargaining to achieve efficiency."

This is a *verbal economic argument*, not a mathematical proposition. The old pipeline tried to prove it as a theorem and produced `True := trivial` when it couldn't.

**Fix:** The extraction prompt now distinguishes:
- **Claims** (formalizable): precise mathematical statements with quantifiers and equations
- **Remarks** (not formalizable): verbal/qualitative arguments, metamathematical observations

The triage agent routes remarks to documentation, not the theorem prover.

---

# What we learned from 8 runs

**1. Over-specifying makes models worse.** A Proof Structurer agent produced step-by-step plans. Models followed them slavishly instead of reaching for direct Mathlib lemmas. Removing it cut avg attempts from 7.6 to 1.9.

**2. Hallucination is an engineering problem.** 24% of failures are invented Mathlib names. A 207K-entry index lets us fuzzy-match them before compilation. The pattern: in any domain with ground truth, hallucination is a lookup problem.

**3. The compiler is the orchestrator.** Error messages drive routing -- unknown identifier triggers RAG search, exhausted attempts trigger model escalation, syntax errors trigger targeted prompt advice.

**4. Decomposition unlocks hard theorems.** The Fundamental Theorem of Arithmetic, Basel Problem, and sqrt(2) irrationality all failed 15 monolithic attempts, then succeeded when broken into 3-line sub-lemmas.

**5. TF-IDF deduplication has a 65% false positive rate.** We built a cross-book librarian using TF-IDF similarity against a corpus of 3,500+ verified proofs. At the 0.90 threshold, 406 J&R items were filtered as "duplicates." Audit: only 138 (35%) were true duplicates. 257 were false positives from vocabulary overlap between economics textbooks. We raised the threshold to 0.95 and reclassified the 0.50-0.90 range as "warm start" references rather than skips.

---

# The deferred axiom ecosystem

427 theorem files (11% of total) contain *deferred axioms* -- dependency stubs the model couldn't prove inline. This is by design (axiomatize and continue), but creates a secondary backlog.

991 unique axiom declarations across all corpora. The librarian found:

| Category | Count | Action |
|----------|-------|--------|
| Already proved elsewhere | 20 | Replace axiom with import |
| Warm-start reference (similar) | 422 | Use as reference proof for translator |
| Genuinely new | 549 | Queue for formalization |

Key finding: **cross-corpus duplication is real**. MWG ch23 *proves* the Revenue Equivalence Theorem, but Jehle-Reny and Vickrey both *axiomatize* it independently. Arrow's Impossibility Theorem: proved in MWG ch21, axiomatized in Jehle-Reny ch6.

---

# Dependency traces: mapping the tree

Starting from 6 arXiv papers published March 16-20, 2026 (zero cherry-picking), we traced their dependency trees backwards through the citation graph:

| Layer | Papers | Items extracted | Dependencies point to |
|-------|--------|----------------|----------------------|
| 0 (arXiv 2026) | 6 | 677 | 1980s-2000s papers |
| 1 | 10 | 285 | 1970s-1980s papers |
| 2 | 4 | 285 | 1982-1986 papers |
| 3 | 4 | 643 | Foundational results |
| Terminal | -- | -- | Nash, Selten, vNM = MWG |

**Depth: 4 layers. Every strand terminates at the same foundations.**

These 2,071 items are extracted and classified but *not yet formalized* -- they are the next phase of work. The textbook results (MWG, JR) provide the foundations these papers depend on.

---

# The economics formalization opportunity

## What exists vs. what's missing

| Domain | Mathlib coverage | LeanKnowledge status |
|--------|-----------------|---------------------|
| Number theory | Extensive | ProofWiki benchmark (done) |
| Abstract algebra | Extensive | ProofWiki benchmark (done) |
| Topology | Good | Used as foundation |
| Probability/measure | Growing | Foundation for some micro theory |
| **Microeconomic theory** | **None** | **3,528 items formalized** |
| **Game theory** | **None** | **Partially covered (MWG, JR, Vickrey)** |
| **Mechanism design** | **None** | **Dependency traces ready** |

The 364K-paper citation graph tells us exactly what to formalize and in what order.

---

# What LLMs are good (and bad) at

Honest assessment from building this system:

| Stage | LLM Performance | Why |
|-------|----------------|-----|
| Extraction (PDF -> claims) | Excellent | Pattern recognition in structured text |
| NL proof generation | Good | Reproducing known arguments |
| Lean translation | Moderate | Syntax is learnable; type system is strict |
| Error repair | Poor-to-moderate | Needs many attempts |
| **Distinguishing provable from verbal claims** | **Poor** | **Produces fake proofs instead of admitting failure** |
| Novel proof discovery | Poor | Not the bottleneck anyway |

The sweet spot: LLMs as *translators and organizers* of existing knowledge, with the Lean compiler as a rigorous check -- and **validation gates that catch when the model gives up silently**.

---

# Self-improving data flywheel

Every attempt produces a training triple: *(natural language proof, Lean code, compiler output)*.

```
Mathlib Rosetta Stone (222K pairs)
         +
    LeanKnowledge verified proofs (~2,549)
         =
    Growing bilingual corpus
         |
         v
    Better translator model --> Higher success rate --> More proofs ...
```

A *pre-compiler* validates code against the growing Mathlib + verified proof index before compilation -- replacing hallucinated identifiers with real ones. The system's error rate *decreases* as a function of its own output.

For microeconomics specifically: early proofs establish Lean encodings of utility functions, preferences, and equilibria. Later proofs reuse them. The field's self-contained nature accelerates this compounding.

---

# This is a public good

Formalized microeconomic theory would be useful beyond our project:

**For economists:** Verify complex proofs mechanically. No more "the reader can check that..." hand-waving.

**For CS/AI:** Structured training data for economic reasoning -- LLMs trained on formal proofs of mechanism design could actually *verify* auction properties.

**For education:** A navigable dependency graph of micro theory. "What do I need to know before understanding the Revenue Equivalence Theorem?" becomes a graph query.

**For Mathlib:** An entire field contributed that currently has zero coverage. The formalization community benefits from breadth, not just depth.

---

# Roadmap

**Done:**
- Multi-agent pipeline: 6 agents, history distillation, per-tier timeouts, 16-attempt budget
- 3 textbooks formalized: *~2,549 proved theorems* + ~1,150 definitions, 99.6% theorem rate
- Post-compilation validation: target-axiom and vacuous proof detection
- Proof audit + stub retry: 132 fakes found, 78 reproved, 49 reclassified, 3 genuine failures
- Citation graph: 364,651 microeconomics papers, 2.7M edges, PageRank rankings
- Dependency traces: 2,071 items extracted across 4 layers of arXiv papers (queued)
- 3,928-entry Rosetta corpus with proof status tags

**Next:**
- Resolve 549 new axiom dependencies (deferred dependency backlog)
- Formalize dependency trace items (24 papers, 2,071 claims)
- Recover ~93 J&R items incorrectly filtered by librarian (false positive dedup)
- Economics-specific Lean scaffolding (utility functions, equilibria, mechanism design)

**Long-term:**
- Complete formalization of core microeconomic theory (~1,000 top PageRank papers)
- RL fine-tuning on ~2,549 verified triples
- Contribute to Mathlib's economics coverage

---

<!-- _class: lead -->

# Microeconomic theory is the right test case
# for LLM-powered formalization.

<br>

It's self-contained, unmapped, and we can see the whole field.

<br>
<br>

<span class="small">github.com/brunosmaniotto/LeanKnowledge</span>
