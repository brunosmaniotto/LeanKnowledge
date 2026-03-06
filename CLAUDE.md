# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Layout

This repo has two top-level directories:
- **`Current/`** — Active codebase (clean rebuild, March 2026). All new work goes here.
- **`Previous/`** — Old codebase kept as reference material. Do not modify.

All commands below assume `Current/` as the working directory unless stated otherwise.

## Build & Test Commands

```bash
# Python is at /c/Python313/python.exe — no uv available, use python directly
/c/Python313/python.exe -m pip install -e "Current/[test]"    # Install with test deps
/c/Python313/python.exe -m pytest Current/tests/ -q           # Run all tests (~61 tests)
/c/Python313/python.exe -m pytest Current/tests/test_triage.py -q           # Single test file
/c/Python313/python.exe -m pytest Current/tests/test_triage.py::test_name -q  # Single test
```

Package is defined in `Current/pyproject.toml` (hatchling build backend, source in `Current/src/leanknowledge/`). Requires Python 3.12+. Core deps: pydantic, pymupdf, litellm. Optional: `google-cloud-documentai` (for Tier 2 PDF extraction).

## Architecture

LeanKnowledge is a multi-agent pipeline that reads mathematical texts, extracts claims, and produces verified Lean 4 proofs. Full design doc: `Current/ARCHITECTURE.md`.

### Pipeline flow (agents 1-6, sequential)

```
PDF → Agent 1 (Extraction) → text
    → Agent 2 (Claim Extraction) → structured claims
    → Agent 3 (Triage) → classified inbox (DEFINITION / THEOREM)
    → Agent 4 (Librarian) → deduplicated backlog
    → Agent 5 (Proof Structurer) → structured proof plan
    → Agent 6 (Translator) → Lean 4 code (with compiler feedback loop)
```

### Agent implementation patterns

All agents follow the same pattern: a class with one main method, using LLM calls from `llm.py` or the Anthropic SDK directly. Prompts live in `Current/prompts/*.md` and are loaded at module level via `PROMPT_PATH`.

| Agent | File | LLM? | Key design choice |
|-------|------|------|-------------------|
| 1 - Extraction | `agents/extraction.py` | Yes (Anthropic SDK direct) | Two-tier PDF: PyMuPDF → Google DocAI escalation via quality gate (`pdf_quality.py`) |
| 2 - Claim Extraction | `agents/claim_extraction.py` | Yes (LiteLLM) | Ensemble: Sonnet + DeepSeek in parallel, Opus arbiter on disagreement |
| 3 - Triage | `agents/triage.py` | No | Fully deterministic type/role mapping. Defines `ItemCategory`, `InboxItem`, `Inbox` |
| 4 - Librarian | `agents/librarian.py` | No | Pluggable `Library` interface. `InMemoryLibrary` for tests, semantic search planned |
| 5 - Proof Structurer | `agents/proof_structurer.py` | Yes (LiteLLM) | Thin wrapper — intelligence lives in `prompts/proof_structurer.md` |
| 6 - Translator | `agents/translator.py` | Yes (LiteLLM) | 5x DeepSeek → 5x Opus escalation. Full attempt history carried forward. Pluggable `LeanCompiler` interface |

### Key modules

- **`schemas.py`** — All Pydantic data contracts: `ExtractedItem`, `ExtractionResult`, `StructuredProof`, `ProofStep`, etc. Shared across all agents.
- **`llm.py`** — Unified LiteLLM gateway. `complete()` for text, `complete_json()` for JSON. Three model tiers configured via env vars.
- **`backlog.py`** — Work queue. `BacklogEntry` tracks status (PENDING → IN_PROGRESS → COMPLETED/FAILED/AXIOMATIZED) and `DependencyInfo` for axiomatized stubs.

### LLM model routing

All LiteLLM calls use env vars with defaults:

| Env var | Default | Used by |
|---------|---------|---------|
| `LK_MODEL_FAST_A` | `anthropic/claude-sonnet-4-20250514` | Agent 2 ensemble |
| `LK_MODEL_FAST_B` | `deepseek/deepseek-reasoner` | Agent 2 ensemble, Agent 6 Tier 1 |
| `LK_MODEL_HEAVY` | `anthropic/claude-opus-4-20250115` | Agent 2 arbiter, Agent 5, Agent 6 Tier 2 |

Agent 1 (Extraction) uses the Anthropic SDK directly with `LK_EXTRACTION_MODEL` (default: `claude-sonnet-4-20250514`).

### What's not built yet

- Pipeline orchestrator / CLI entrypoints
- Agent 7 (Knowledge Agent): reference graph + strategy DB
- Dependency resolution (BLOCKED/READY status)
- Real Lean compiler integration (`LeanCompiler` is an interface only)
- Semantic search for Librarian (currently text similarity)

## Conventions

- Axioms are treated as definitions throughout the pipeline (they define structure properties, not foundational axioms).
- Axiomatized dependencies: when the prover hits an unproven dependency, it stubs it as a Lean axiom and adds it to the backlog — no recursive proving.
- Agent prompts in `Current/prompts/` are living documents with iteration notes. When translation fails, iterate on the prompt, not the agent code.
- Training triples `(StructuredProof, lean_code, compiler_output)` are collected from every translation attempt for future RL fine-tuning.
