# LeanKnowledge — Developer Guide

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Layout

This is a flat layout — source, tests, prompts, and outputs are at the top level (no `Current/` wrapper).

```
src/leanknowledge/     # Python package
tests/                 # Test suite (~34 files)
prompts/               # Agent prompts + categories/
scripts/               # Utility scripts
data/                  # Mathlib index, ProofWiki corpus, OpenAlex
outputs/
  microtheory/         # MWG, Jehle-Reny, Vickrey results
  benchmarks/          # ProofWiki benchmark runs (general math)
  dependency_traces/   # Extraction-only backlogs (no proofs yet)
  run_scripts/         # One-off orchestration scripts
```

## Build & Test Commands

```bash
pip install -e ".[test]"                    # Install with test deps
pytest tests/ -q                            # Run all tests
pytest tests/test_triage.py -q              # Single test file
pytest tests/test_triage.py::test_name -q   # Single test
```

Package: `pyproject.toml` (hatchling build, source in `src/leanknowledge/`). Python 3.12+.

Optional install groups: `pip install -e ".[test,openalex,google]"`
- `test` — pytest
- `google` — google-cloud-documentai (Tier 2 PDF extraction)
- `openalex` — networkx (citation graph PageRank)

CLI entry point: `leanknowledge` → `pipeline:main`

## Architecture

LeanKnowledge is a multi-agent pipeline that reads mathematical texts, extracts claims, and produces verified Lean 4 proofs. Full design doc: `ARCHITECTURE.md`.

### Pipeline flow

```
PDF → Agent 1 (Extraction) → text
    → Agent 2 (Claim Extraction) → structured claims
    → Agent 3 (Triage) → classified inbox (DEFINITION / THEOREM)
    → Agent 4 (Librarian) → deduplicated backlog
    → Agent 6 Direct phase (3× DeepSeek, no plan) → if SUCCESS, done
    → Agent 6 Guided phase (Agent 5 bypassed):
        Tier 1: 7× DeepSeek → Tier 2: 5× Gemini 2.5 Pro
        → Tier 3: Decompose into sub-lemmas, prove each independently
    Budget: 3 + 7 + 5 + 1 = 16 max attempts per theorem
```

### Proof validation (post-compilation)

After Lean compilation succeeds, `validate_proof_output()` in `translator.py` checks
that the target item appears as an actual `theorem`/`lemma` declaration, not as an
`axiom`. This prevents target-as-axiom stubs from being marked as successes.
Dependency axioms (names that don't match the target) remain allowed.

Outcomes:
- `SUCCESS` — target proved (dependency axioms OK)
- `TARGET_AXIOMATIZED` — compiled but target was axiomatized, not proved
- `DECOMPOSED` — assembly verified with axiom stubs, sub-lemmas queued

Rosetta Stone entries include a `proof_status` field: `"verified"` (no axioms) or
`"deferred_axioms"` (target proved but file has dependency axiom stubs).

### Agent implementation patterns

All agents follow the same pattern: a class with one main method, using LLM calls from `llm.py` or the Anthropic SDK directly. Prompts live in `prompts/*.md` and are loaded at module level via `PROMPT_PATH`.

| Agent | File | LLM? | Key design choice |
|-------|------|------|-------------------|
| 1 - Extraction | `agents/extraction.py` | Yes (Anthropic SDK direct) | Two-tier PDF: PyMuPDF → Google DocAI escalation via quality gate (`pdf_quality.py`) |
| 2 - Claim Extraction | `agents/claim_extraction.py` | Yes (LiteLLM) | Ensemble: Sonnet + DeepSeek in parallel, Opus arbiter on disagreement |
| 3 - Triage | `agents/triage.py` | No | Fully deterministic type/role mapping. Defines `ItemCategory`, `InboxItem`, `Inbox` |
| 4 - Librarian | `agents/librarian.py` | No | Pluggable `Library` interface. `InMemoryLibrary` for tests, semantic search planned |
| 5 - Proof Structurer | `agents/proof_structurer.py` | Yes (LiteLLM) | **INACTIVE** — structured plans degraded model performance. Code preserved. |
| 6 - Translator | `agents/translator.py` | Yes (LiteLLM) | Two-phase, three-tier: Direct (3× DeepSeek) → Guided (7× DeepSeek → 5× Gemini 2.5 Pro) → Tier 3 decomposition. 16 attempts max. |
| 7 - Supervisor | `agents/supervisor.py` | Optional | Post-run analysis: error classification, identifier analysis, recommendations. |

### Key modules

- **`schemas.py`** — All Pydantic data contracts: `ExtractedItem`, `ExtractionResult`, `StructuredProof`, `ProofStep`, etc. Shared across all agents.
- **`llm.py`** — Unified LLM gateway. Three backends: LiteLLM (API), Claude Code CLI (`cli/claude`), Gemini CLI (`cli/gemini`). `complete()` routes by model prefix.
- **`backlog.py`** — Work queue. `BacklogEntry` tracks status (READY → IN_PROGRESS → COMPLETED/FAILED/AXIOMATIZED).
- **`prompt_tuner.py`** — Cross-theorem learning. Static rules (hand-written regex triggers) + dynamic patterns (extracted from compilation failures). Injected into translator system prompt per-attempt.
- **`mathlib_index.py`** — TF-IDF + optional embedding RAG over 207K Mathlib declarations. Used by translator for identifier hints and by pre-compiler for fuzzy matching.
- **`loogle.py`** — HTTP client for `loogle.lean-lang.org` (type-based Mathlib search). Combined with TF-IDF results in translator.

### Lean compilation stack (`lean/` subpackage)

| Module | Role |
|--------|------|
| `compiler.py` | `RealLeanCompiler` — wraps `lake lean` or standalone `lean`. Writes scratch files to `<project>/LeanKnowledge/Scratch_<worker_id>.lean` |
| `repl.py` | `LeanREPL` — caches `LEAN_PATH` from `lake env` to skip 2-5s overhead per compilation |
| `pre_compiler.py` | Deterministic fixes applied before every compile (free, doesn't cost an attempt): import management, identifier fuzzy-match, Lean 3→4 syntax, class/API renames, deprecated patterns |
| `errors.py` | Lean error classification and parsing |
| `repair_db.py` | 3-tier deterministic repair after compile failures: Tier A (exact pattern), Tier B (heuristic), Tier C (falls through to LLM retry) |

### Translator budget details

- **Operational failures** (empty output, truncated code, missing olean, timeout) do NOT count against the 16-attempt budget. Up to 3 operational retries are allowed before they start counting.
- **Definitions** have a separate path: `translate_definition()` with 6 attempts (`LK_DEFINITION_MAX_ATTEMPTS`), separate model config, and outcome `DEFINITION_SUCCESS`.

### Environment variables

**Core model routing** (`llm.py`):

| Env var | Default | Used by |
|---------|---------|---------|
| `LK_MODEL_FAST_A` | `anthropic/claude-sonnet-4-20250514` | Agent 2 ensemble (Sonnet) |
| `LK_MODEL_FAST_B` | `openai/Goedel-LM/Goedel-Prover-V2-8B` | Agent 2 ensemble (Goedel-Prover) |
| `LK_MODEL_HEAVY` | `anthropic/claude-sonnet-4-20250514` | Agent 2 arbiter |
| `LK_CLAUDE_CLI` / `LK_GEMINI_CLI` | `claude` / `gemini` | CLI backend executable paths |

**Translator** (`agents/translator.py`):

| Env var | Default | Purpose |
|---------|---------|---------|
| `LK_TRANSLATOR_DIRECT_MODEL` | same as TIER1 | Direct phase model |
| `LK_TRANSLATOR_DIRECT_ATTEMPTS` | `3` | Direct phase budget |
| `LK_TRANSLATOR_TIER1_MODEL` | `deepseek/deepseek-reasoner` | Tier 1 model |
| `LK_TRANSLATOR_TIER1_ATTEMPTS` | `7` | Tier 1 budget |
| `LK_TRANSLATOR_TIER2_MODEL` | `gemini/gemini-2.5-pro` | Tier 2 model |
| `LK_TRANSLATOR_TIER2_ATTEMPTS` | `5` | Tier 2 budget |
| `LK_TRANSLATOR_TIER3_ENABLED` | `1` | Enable decomposition |
| `LK_TRANSLATOR_ORACLE_ENABLED` | `0` | Oracle tier (disabled) |
| `LK_LOOGLE_ENABLED` | `1` | Enable Loogle search in translator |

**Free CLI routing** (use subscription instead of API credits):
```bash
export LK_TRANSLATOR_DIRECT_MODEL="cli/gemini"
export LK_TRANSLATOR_TIER1_MODEL="cli/gemini"
export LK_TRANSLATOR_TIER2_MODEL="cli/claude"
export LK_TRANSLATOR_TIER3_MODEL="cli/claude"
```

### Output directory structure

```
outputs/
  microtheory/           # Microeconomic theory formalization results
    mwg_ch1/ ... mwg_ch23/   # MWG textbook chapters
    mwg_appendix/
    jehle_reny/
    vickrey_1961/
  benchmarks/            # ProofWiki benchmark runs (general math)
    run7/, run8/, ...
  dependency_traces/     # Extraction-only backlogs (no proofs yet)
    arxiv_2026_strands/
    arxiv_deps_layer2/
    arxiv_deps_layer3/
    strands/
```

Each run directory contains:
- `lean/` — compiled .lean files (successes)
- `failures/` — JSON failure records per theorem
- `triples/` — training triples (structured_proof + lean_code + compiler_output)
- `rosetta_stone.jsonl` — verified NL→Lean corpus (append-only, with `proof_status` field)
- `backlog.json` — backlog state (resumable)

## Test patterns

- No `conftest.py` — tests are fully self-contained with inline mock fixtures.
- Common pattern: `MockCompiler(succeed_on=N)` and `AlwaysFailCompiler` defined per test file.
- Tests do not require API keys or a Lean installation.

## Conventions

- Axioms are treated as definitions throughout the pipeline (they define structure properties, not foundational axioms).
- Axiomatized dependencies: when the prover hits an unproven dependency, it stubs it as a Lean axiom and adds it to the backlog — no recursive proving.
- Agent prompts in `prompts/` are living documents with iteration notes. When translation fails, iterate on the prompt, not the agent code.
- Training triples `(StructuredProof, lean_code, compiler_output)` are collected from every translation attempt for future RL fine-tuning.
- Pre-compiler fixes are free — they run before every compile and don't count as attempts.

## Current results (post-audit, post-retry, 2026-03-23)

| Corpus | Total items | Definitions | Theorems | Proved | Failed | Rate |
|--------|-------------|-------------|----------|--------|--------|------|
| MWG | 1,948 | ~700 | ~1,250 | ~1,246 | 1 | 99.7% |
| Jehle & Reny | 1,546 | ~400 | ~1,150 | ~1,144 | 2 | 99.5% |
| Vickrey | 236 | ~50 | ~160 | ~159 | 0 | 99.4% |
| **Total** | **3,730** | **~1,150** | **~2,560** | **~2,549** | **3** | **99.6%** |

Rosetta corpus: 3,928 entries (3,501 verified, 427 deferred axioms).
Dependency traces: 2,071 items extracted and queued (not yet attempted).
