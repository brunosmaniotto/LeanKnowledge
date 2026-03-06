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

### LLM-Powered Formalization of Known Mathematics

<br>

Bruno Smaniotto

<span class="small">March 2026</span>

---

# The standard framing is backwards

The AI + theorem proving community is focused on one question:

> Can LLMs *discover* new proofs?

AlphaProof, DeepSeek-Prover, Lean-STaR — all chase novel results.

Meanwhile, **centuries of proven mathematics remain informal.** Mathlib — the largest Lean library — has ~200K formalized theorems, built by hundreds of contributors over years of manual effort.

Textbooks contain *millions* of proven results that no one has formalized.

---

# The overlooked problem is bigger

Formalizing *known* mathematics is not a consolation prize. It may be **the fastest path to automatic provers**.

**Why?**

- Mathematical research doesn't happen in a vacuum. It connects fields and builds heavily on what came before.
- A theorem prover that can't access formalized foundations is like a researcher who hasn't read the literature.
- Every formalized result becomes a *lemma* available to future proof search — the library compounds.

Bottom-up formalization creates the infrastructure that top-down proving needs.

---

# Even experts can't track what's known

In 2023, a widely-discussed case: an AI system appeared to help crack an open problem related to Erdos. The excitement was short-lived — mathematicians discovered the "new" proof essentially rediscovered an existing but *obscure* result.

**This is the real lesson.** The bottleneck in mathematics is not always creativity — it's *retrieval*. The literature is vast, scattered across languages, decades, and subfields.

No single mathematician can know everything that's been proven. But a formalized, searchable knowledge base *can*.

---

# LeanKnowledge: the idea

A multi-agent pipeline that reads mathematical texts and produces **machine-verified Lean 4 proofs**, building a growing knowledge graph.

<br>

```
PDF / Paper                                      Verified Knowledge Graph
    |                                                      ^
    v                                                      |
 Extract --> Prove --> Translate --> Verify --> Integrate --+
 claims      NL        Lean 4       Lean        tag &
             proof     code         compiler    connect
```

The key insight: formalizing known math is a *translation* problem, and LLMs are good at translation.

---

# Two modes, one system

**Bottom-up:** Feed a textbook chapter. Most claims have proofs. They flow through the pipeline sequentially, building foundations.

**Top-down:** Feed a research paper. Many claims reference prior work without proof. They go to a *dependency backlog* — a queue of what needs to be formalized first.

The two modes converge: textbook work resolves what papers need, and the backlog reveals which foundations to prioritize next.

There is no mode switch. The architecture naturally produces both behaviors depending on the input.

---

# The Rosetta Stone

To translate natural language math into Lean 4, the system needs a *bilingual corpus*.

**Rosetta Stone** = 222,000 NL-to-Lean pairs generated from all of Mathlib.

For every Lean declaration in Mathlib, an LLM generates a natural-language description: the statement in plain English, the proof strategy, and what it depends on.

This corpus serves two purposes:
1. **Retrieval** — the Librarian agent searches it to find relevant Mathlib lemmas for each new proof
2. **Training** — it becomes fine-tuning data for a specialized translator model

---

# The Rosetta Stone compounds

This is where bottom-up formalization pays off.

Every theorem that LeanKnowledge verifies generates a *new* Rosetta Stone entry: a known mapping between natural language and Lean 4 code that didn't exist before.

```
Mathlib Rosetta Stone (222K pairs)
         +
    LeanKnowledge verified proofs
         =
    Growing bilingual corpus
         |
         v
    Better translator model
         |
         v
    Higher verification rate
         |
         v
    More verified proofs ...
```

The system generates its own training data. The more it formalizes, the better it gets.

---

# What LLMs are good (and bad) at

Honest assessment from building this system:

| Stage | LLM Performance | Why |
|-------|----------------|-----|
| Extraction (PDF -> claims) | Excellent | Pattern recognition in structured text |
| NL proof generation | Good | Reproducing known arguments, connecting ideas |
| Lean translation | Moderate | Syntax is learnable, but Lean's type system is strict |
| Error repair | Poor-to-moderate | Needs many attempts; error messages are cryptic |
| Novel proof discovery | Poor | This is genuinely hard; not the bottleneck anyway |

The sweet spot: LLMs as *translators and organizers* of existing knowledge, with the Lean compiler as a rigorous check.

---

# Architecture: the right model for each job

Not every stage needs the same model.

| Stage | Prototype | Production | Rationale |
|-------|-----------|------------|-----------|
| Extraction | Claude | Claude API | High accuracy, low volume |
| Proof Agent | Claude | Claude API | Needs strong reasoning |
| Translator | Claude | Fine-tuned 8B model | High throughput, trainable on Rosetta Stone |
| Verifier | Claude | Lean compiler + RL repair | Deterministic check + learned repair |
| Knowledge Agent | Claude | Claude API | Integration & strategy |
| Resolver (hard proofs) | Claude | Heavy reasoning model | Deep thinking, low volume |

The transition: **general LLM -> specialized local models** where the Rosetta Stone provides enough training signal.

---

# Current results

| Component | Status |
|-----------|--------|
| Pipeline (8 agents) | All operational via Claude Code CLI |
| MWG Textbook (Mas-Colell, Whinston, Green) | Chapters 1-23 extracted |
| Verified theorems | ~69 from microeconomic theory |
| Rosetta Stone corpus | 222K NL-Lean pairs (full Mathlib) |
| Citation graph | Built from Semantic Scholar + OpenAlex |
| Domain | Microeconomic theory (preferences, utility, comparative statics) |

Starting domain chosen deliberately: microeconomic theory is *axiomatic and rigorous* but largely unfformalized — a good testbed.

---

# What this tells us about LLMs

Three takeaways relevant beyond this project:

**1. LLMs as consolidators, not discoverers.**
The highest-value application may be organizing and verifying what humanity already knows, not pushing frontiers.

**2. Translation + verification is a powerful pattern.**
LLMs generate candidates; a formal system checks them. This sidesteps hallucination — wrong proofs are caught by the compiler, not by human review.

**3. Self-improving data flywheels.**
Systems that generate their own training data through verified outputs can compound capability in narrow domains.

---

# Roadmap

**Near-term:**
- Fine-tune Goedel-Prover-V2 (8B) on Rosetta Stone for the translator stage
- Expand to 2-3 additional mathematical domains
- Build the RL repair loop for the verifier

**Medium-term:**
- Scale the Rosetta Stone as new proofs are verified (the flywheel)
- Measure: does translator accuracy improve as the corpus grows?
- Open-source the Rosetta Stone corpus

**Long-term question:**
At what corpus size does a specialized model surpass a general LLM at Lean translation?

---

<!-- _class: lead -->

# The fastest way to build a prover
# is to formalize what we already know.

<br>
<br>

<span class="small">github.com/brunosmaniotto/LeanKnowledge</span>
