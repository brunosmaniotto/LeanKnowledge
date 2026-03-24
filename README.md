# LeanKnowledge

**Exploring how LLMs can help formalize microeconomic theory in Lean 4.**

LeanKnowledge is a multi-agent system that reads economics textbooks, extracts mathematical claims, and produces machine-verified proofs in Lean 4. It coordinates Claude, Gemini, and DeepSeek through a tiered translation pipeline, using the Lean compiler as the ground-truth feedback signal.

The motivation is simple: **formalizing known mathematics is a translation problem, and LLMs are good at translation.** Rather than chasing novel proofs, this project systematically converts the canonical results of microeconomic theory into machine-verified code — work that would take a human proof engineer months, done in days with AI as the drafter and Lean as the arbiter.

The project is also an exercise in prompt engineering, model routing, and failure analysis. It was built almost entirely using Claude Code as the development environment.

## Why microeconomic theory?

Most AI formalization work targets pure mathematics — number theory, algebra, topology. Microeconomics is a deliberate choice:

1. **Absent from Mathlib.** Mathlib has ~263K formalized theorems, almost entirely pure math. Utility maximization, Nash equilibria, mechanism design, contract theory — all untouched. Every proof here is genuinely new formalization.

2. **Self-contained.** Microeconomic theory draws on optimization, fixed-point theorems, and basic real analysis. It doesn't require the deep dependencies that make formalizing, say, algebraic geometry intractable.

3. **Uniform proof patterns.** Constrained optimization, envelope theorems, existence via fixed points, comparative statics. These recurring structures play to an LLM's strength.

4. **We can map the whole field.** Using the OpenAlex citation graph (364,651 papers, 2.7M citation edges), we have a quantifiable picture of which papers are most influential, how they connect, and what remains to be formalized.

## Results

### Microeconomics textbooks

| Corpus | Total items | Definitions | Theorems | Proved | Failed | Rate |
|--------|-------------|-------------|----------|--------|--------|------|
| MWG (23 chapters + appendix) | 1,948 | ~700 | ~1,250 | ~1,246 | 1 | 99.7% |
| Jehle & Reny | 1,546 | ~400 | ~1,150 | ~1,144 | 2 | 99.5% |
| Vickrey 1961 | 236 | ~50 | ~160 | ~159 | 0 | 99.4% |
| **Total** | **3,730** | **~1,150** | **~2,560** | **~2,549** | **3** | **99.6%** |

Definitions (economic assumptions, preference structures, equilibrium concepts) are formalized as Lean `structure`/`def`. Theorem rate counts only items requiring actual proofs. All runs used free CLI backends (Gemini + Claude subscriptions).

### ProofWiki benchmarks (pipeline development)

Before targeting economics, the pipeline was developed and stress-tested on 2,000 ProofWiki theorems (number theory, algebra, topology, analysis).

| Run | Theorems | Proved | Rate | Models |
|-----|----------|--------|------|--------|
| Run 7 | 1,000 | 864 | 96.4% | Gemini 2.5 Pro (all tiers) |
| Run 8 | 1,000 | 571 | 57.1% | DeepSeek + Gemini (tiered) |
| **Combined** | **2,000** | **1,435** | **75.7%** | |

88% of winning proofs came from DeepSeek (the cheapest model). The lessons from these runs — removing the proof structurer, adding decomposition, building the pre-compiler — directly shaped the system that formalized the textbooks.

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
