# LeanKnowledge

**Exploring how LLMs can formalize mathematical results in Lean 4 at scale.**

There are over 3.6 million mathematical papers indexed in MathSciNet, with more than 120,000 added every year — by some estimates, a quarter of a million new theorems are proved annually. The vast majority of these results are probably correct. But mathematical writing is aimed at specialists: proofs routinely leave steps implicit, compress arguments, or skip details that the intended reader, usually another expert in the same subfield, can in principle reconstruct. As Voevodsky put it, *"a technical argument by a trusted author, which is hard to check and looks similar to arguments known to be correct, is hardly ever checked in detail"*.<sup>1</sup> This is especially true in niche or recently developed fields, where results haven't been widely scrutinized. And because mathematics has a deep logical dependency structure, a single flawed result can quietly put in question everything built on top of it.

Proof assistants like Lean provide a way to actually verify results: formalize a proof, and the compiler checks correctness all the way down to the axioms. But formalization is enormously labor-intensive. Wiedijk estimated that it takes *"almost a full week to formalize a single page from an undergraduate mathematics textbook"*,<sup>2</sup> and that's for experienced users. The Flyspeck project (formal verification of the Kepler conjecture) required roughly 20 person-years of work.<sup>3</sup> With mathematical output growing at 3–4% per year and the existing literature already in the millions, manually formalizing even a meaningful fraction of it is simply not feasible.

LeanKnowledge is an exploration of what large-scale, LLM-based formalization could look like. The motivation is straightforward: **formalizing known mathematics is a translation problem, and LLMs are good at translation.** Proving *new* results with AI is an exciting prospect, but still largely out of reach — Terence Tao estimates that only around one to two percent of currently open problems are simple enough for today's tools to handle with minimal human guidance.<sup>4</sup> We remove one layer of uncertainty (is this result true in the first place, and how would one prove it?) and focus on translation: given a mathematical statement together with a natural-language proof, can we use LLMs to produce a rigorous, machine-verified formalization?

By systematically converting existing mathematical knowledge into verified Lean code, we can build a large corpus of natural-language–Lean proof pairs. This is useful in several ways: as training data for future proof-generation models, as a searchable database of formalized results that can provide hints when tackling new problems, and as a way to identify common patterns between proofs in different areas of mathematics that would be hard for humans to spot. More broadly, a large corpus of formalized natural-language statements can help improve how LLMs reason deductively — proof assistants like Lean can verify not just mathematical arguments, but other forms of structured reasoning as well.

## Why microeconomic theory?

We start with microeconomic theory. Most AI formalization work targets pure mathematics — number theory, algebra, topology. Microeconomics is a deliberate choice:

1. **Absent from Mathlib.** Mathlib has ~263K formalized theorems, almost entirely pure math. Utility maximization, Nash equilibria, mechanism design, contract theory — all untouched. Every proof here is genuinely new formalization.

2. **Self-contained.** Microeconomic theory mostly draws on optimization, fixed-point theorems, and real analysis. It doesn't require the deep dependencies that make formalizing, say, algebraic geometry intractable.

3. **Uniform proof patterns.** Constrained optimization, envelope theorems, existence via fixed points, comparative statics. These recurring structures play to an LLM's strength.

4. **We can map the whole field.** OpenAlex indexes over 1.6 million microeconomics papers; filtering to those with 10+ citations gives 364,651 papers and 2.7M citation edges. We have a quantifiable picture of which papers are most influential, how they connect, and what remains to be formalized. 

## Results

### Microeconomics textbooks

| Corpus | Total items | Definitions | Theorems | Proved | Failed | Rate |
|--------|-------------|-------------|----------|--------|--------|------|
| MWG (23 chapters + appendix) | 1,948 | ~700 | ~1,250 | ~1,246 | 1 | 99.7% |
| Jehle & Reny | 1,546 | ~400 | ~1,150 | ~1,144 | 2 | 99.5% |
| Vickrey 1961 | 236 | ~50 | ~160 | ~159 | 0 | 99.4% |
| **Total** | **3,730** | **~1,150** | **~2,560** | **~2,549** | **3** | **99.6%** |

Definitions (economic assumptions, preference structures, equilibrium concepts) are formalized as Lean `structure`/`def`. Theorem rate counts only items requiring actual proofs.

### ProofWiki benchmarks (pipeline development)

Before targeting economics, the pipeline was developed and calibrated on ProofWiki theorems spanning number theory, algebra, topology, and analysis. The lessons from these runs — removing the proof structurer, adding decomposition, building the pre-compiler — directly shaped the system that formalized the textbooks.

## How it works

### Pipeline

```
Paper --> Extract claims --> Classify --> Deduplicate --> Translate --> Verify --> Validate
          (Agent 1-2)       (Agent 3)    (Agent 4)      (Agent 6)    (Lean)    (proof check)
```

Six agents coordinate the flow from PDF to verified proof. Agent 5 (Proof Structurer) was built, tested, and deliberately removed after finding that structured plans made models produce worse proofs.

### Translation engine

```
Phase 1: DIRECT (3x DeepSeek Reasoner)
  Theorem statement + NL proof. No plan. 58% of successes solve here.

Phase 2: GUIDED (if direct fails — carries all Phase 1 failures as context)
  Tier 1:  7x DeepSeek Reasoner     — cheap, full error history
  Tier 2:  5x Gemini 2.5 Pro        — model escalation
  Tier 3:  Decompose into sub-lemmas, prove each independently
```

16 attempts max per theorem. A **pre-compiler** fixes code before each compilation attempt: fuzzy-matching identifiers against the 207K-declaration Mathlib index, fixing deprecated patterns, injecting imports. A **prompt tuner** learns from failures within each run and injects targeted hints into subsequent attempts.

### Proof validation

After Lean compilation succeeds, `validate_proof_output()` checks that the target theorem is actually proved — not axiomatized, not vacuous (`True := trivial`), not a dummy wrapper. This catches models that silently give up instead of admitting failure.

## Architecture

Full design doc: [`ARCHITECTURE.md`](ARCHITECTURE.md)

```
src/leanknowledge/
|-- agents/           # 6 agents (translator.py is the core)
|-- lean/             # Compiler interface, pre-compiler, repair DB
|-- llm.py            # Unified LLM gateway (LiteLLM + CLI backends)
|-- mathlib_index.py  # 207K-declaration RAG index
|-- openalex.py       # Citation graph: fetch, PageRank, download
|-- prompt_tuner.py   # Cross-theorem learning
|-- pipeline.py       # Orchestrator + CLI
+-- schemas.py        # Pydantic data contracts
```

~15,300 lines of Python, ~10,800 lines of tests.

## Quick start

```bash
# Install (Python 3.12+)
pip install -e ".[test,openalex]"

# Run tests
pytest tests/ -q

# Build citation graph
python scripts/fetch_openalex.py all --concept C175444787 --min-citations 100 --output data/openalex

# ProofWiki benchmark (requires Lean 4 + Mathlib + API keys)
python scripts/run_proofwiki.py --data data/proofwiki.json --lean-project ~/lean-project --max 10
```

**Requirements:** Python 3.12+, Lean 4 + Mathlib via [elan](https://github.com/leanprover/elan), API keys for DeepSeek (`DEEPSEEK_API_KEY`), Anthropic (`ANTHROPIC_API_KEY`), and Google/Vertex AI (`GOOGLE_APPLICATION_CREDENTIALS`). Or use free CLI backends (`cli/claude`, `cli/gemini`).

## Output organization

```
outputs/
  microtheory/           # Primary target: microeconomic theory
    mwg_ch1/ ... mwg_ch23/   # MWG textbook chapters
    jehle_reny/              # Jehle & Reny textbook
    vickrey_1961/            # Vickrey seminal paper
  benchmarks/            # Pipeline validation (general math)
    run7/, run8/             # ProofWiki benchmark runs
  dependency_traces/     # Extraction-only (not yet formalized)
    arxiv_2026_strands/      # 6 arXiv papers + dependency layers
```

## What's next

- **Resolve 549 axiom dependencies** from the deferred-axiom scan
- **Formalize 2,071 dependency trace items** (4 layers of arXiv papers back to foundations)
- **Economics-specific Lean scaffolding** — utility functions, equilibria, mechanism design structures
- **RL fine-tuning** on ~2,549 verified proof triples

## License

[MIT](LICENSE)

---

<sup>1</sup> Vladimir Voevodsky, ["The Origins and Motivations of Univalent Foundations"](https://www.ias.edu/ideas/2014/voevodsky-origins), Institute for Advanced Study, 2014.

<sup>2</sup> Freek Wiedijk, ["Formal Proof — Getting Started"](https://www.ams.org/notices/200811/tx081101408p.pdf), *Notices of the AMS*, 2008.

<sup>3</sup> Thomas Hales et al., ["A Formal Proof of the Kepler Conjecture"](https://arxiv.org/abs/1501.02155), *Forum of Mathematics, Pi*, 2017.

<sup>4</sup> Terence Tao, on [GPT-5.2 solving an Erdős problem](https://the-decoder.com/terence-tao-says-gpt-5-2-pro-cracked-an-erdos-problem-but-warns-the-win-says-more-about-speed-than-difficulty/), 2026.
