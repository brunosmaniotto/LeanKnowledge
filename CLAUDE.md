# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

LeanKnowledge is an LLM-powered pipeline that formalizes mathematical theorems from textbooks/papers into verified Lean 4 code and organizes them into a knowledge graph. See [ARCHITECTURE.md](ARCHITECTURE.md) for full system design.

## Build & Run Commands

### Python
```bash
uv sync                    # Install Python dependencies
leanknowledge extract --pdf FILE --start-page N --end-page N --domain DOMAIN [--source LABEL]
leanknowledge status       # Show backlog state
leanknowledge next         # Formalize next ready item
leanknowledge run          # Formalize all ready items
leanknowledge feed         # Run Feeder agent on blocked backlog items
leanknowledge formalize --name NAME --statement STMT --domain DOMAIN  # Single theorem, bypasses backlog
leanknowledge migrate      # Migrate JSON → SQLite (opt-in dual-write)
```

### Training
```bash
# Prepare data (splits Rosetta Stone into train/val/test)
python training/prepare_data.py --pairs_dir rosetta_stone/pairs --output_dir training/data

# Train QLoRA adapter (on server with GPU)
python training/train_translator.py --base_model Goedel-LM/Goedel-Prover-V2-8B

# Evaluate
python training/eval_translator.py --adapter_path training/adapters/translator_v0

# SLURM submission
sbatch training/slurm_train.sh
sbatch training/slurm_eval.sh
```

### Rosetta Stone Corpus
```bash
# Single module
python3 rosetta_stone/generate.py --module Mathlib.Order.Defs --mathlib-root .lake/packages/mathlib --output rosetta_stone/pairs/output.json

# All submodules (batch processing with resume)
python3 rosetta_stone/generate.py --module Mathlib.Order --mathlib-root .lake/packages/mathlib --all-submodules --resume --pairs-dir rosetta_stone/pairs

# Extract-only (no Claude calls, just parse declarations)
python3 rosetta_stone/generate.py --module Mathlib.Order.Defs --mathlib-root .lake/packages/mathlib --output out.json --extract-only

# Rebuild index from existing pairs
python3 rosetta_stone/generate.py --build-index --pairs-dir rosetta_stone/pairs
```

### Lean 4
```bash
lake update                # Download/update Mathlib
lake build                 # Compile LeanProject
lake env lean FILE         # Compile a single .lean file with Mathlib access
```

## Testing
```bash
uv run pytest tests/ -q    # 37+ tests
```

## Key File Paths

### Pipeline Core
- `src/leanknowledge/pipeline.py` — Orchestrator: chains all stages, CLI entrypoints
- `src/leanknowledge/schemas.py` — Pydantic models for all inter-stage data contracts
- `src/leanknowledge/backlog.py` — Persistent work queue with dependency-aware scheduling (JSON + optional SQLite)
- `src/leanknowledge/router.py` — Claim dispatch (checks Librarian, routes to pipeline or backlog)
- `src/leanknowledge/claude_client.py` — Anthropic SDK wrapper with prompt caching, usage tracking, batch API
- `src/leanknowledge/deepseek_client.py` — DeepSeek API alternative backend
- `src/leanknowledge/llm_gateway.py` — LiteLLM gateway (opt-in via `LK_USE_GATEWAY=1`)

### Agents
- `agents/extraction.py` — Stage 0: text → ExtractedItem (Marker pre-converts PDF → markdown; agent is text-only)
- `agents/proof.py` — Stage 1: theorem → StructuredProof
- `agents/translator.py` — Stage 2: StructuredProof → LeanCode (accepts tactic hints from Strategy KB)
- `agents/verifier.py` — Stage 3: compile-repair loop (max 6 iterations, tactic hints on re-translation)
- `agents/knowledge.py` — Stage 4: deterministic tagging (no LLM calls)
- `agents/librarian.py` — RAG search: embedding → BM25 → Claude Haiku
- `agents/resolver.py` — Tier 2: heavy-model loop for axiomatized failures
- `agents/feeder.py` — Procurement agent for blocked backlog items (with citation graph suggestions)

### Lean Integration
- `lean/compiler.py` — Lean 4 compiler interface (`lake env lean`)
- `lean/errors.py` — Error parsing and classification
- `lean/repair_db.py` — 3-tier deterministic repair patterns
- `lean/repl.py` — Cached Lean environment (skips Lake overhead per compilation)

### Search Infrastructure
- `src/leanknowledge/embedding_index.py` — Sentence-transformer embedding search
- `src/leanknowledge/librarian_index.py` — BM25 search index (Rosetta Stone + pipeline pairs)
- `src/leanknowledge/loogle_client.py` — Loogle API client (type-based Mathlib search, no LLM)

### Storage & Data
- `src/leanknowledge/storage.py` — SQLite backend (dual-write with JSON)
- `src/leanknowledge/strategy_kb.py` — Strategy Knowledge Base (221K entries, wired into Proof/Translator/Verifier)
- `src/leanknowledge/citation_suggestions.py` — Citation graph paper suggestions for Feeder

### Training
- `training/train_translator.py` — QLoRA training (Goedel-Prover-V2-8B base)
- `training/prepare_data.py` — Data splitting (90/5/5, stratified by complexity)
- `training/data_loader.py` — Rosetta Stone → HuggingFace Dataset loader
- `training/eval_translator.py` — Evaluation harness (pass@1, pass@k with Lean compiler)
- `training/train_repair.py` — DPO repair adapter (stub)

### Other
- `prompts/*.md` — Agent prompt templates
- `rosetta_stone/generate.py` — Mathlib NL-Lean pair generator
- `scripts/run_mwg_batch.py` — MWG batch extraction runner
- `scripts/triage_backlog.py` — Reset stuck IN_PROGRESS/FAILED items
- `scripts/setup_models.py` — Download Goedel-Prover-V2-8B from HuggingFace

## Key Technical Details

- **Python 3.12+**, managed with `uv`. Build backend: hatchling. Package source is `src/leanknowledge/`.
- **Lean 4 v4.27.0** with **Mathlib v4.27.0**. Version pinned in `lean-toolchain`.
- Lake project config in `lakefile.toml`: `relaxedAutoImplicit = false`, Mathlib linter enabled.
- `elan` (Lean version manager) expected at `~/.elan/bin`. The compiler prepends this to PATH.
- All agent prompts are in `prompts/`: `extraction_agent.md`, `proof_agent.md`, `lean_translation.md`, `knowledge_agent.md`, `resolver.md`, `librarian.md`, `axiom_translation.md`, `rosetta_stone.md`.
- Domain enum in `schemas.py`: real_analysis, topology, algebra, measure_theory, microeconomics, game_theory, welfare_economics.
- **CLAUDECODE env var**: `os.environ.pop("CLAUDECODE", None)` in `claude_client.py` prevents interference when running inside Claude Code.
- **LK_USE_GATEWAY=1**: Activates LiteLLM gateway for unified multi-provider LLM routing.
- **SQLite**: Activated after `leanknowledge migrate`. Dual-writes JSON + SQLite. Incremental single-entry writes for status updates.
- Backlog status flow: PENDING → BLOCKED → READY → IN_PROGRESS → COMPLETED/FAILED/AXIOMATIZED/SKIPPED.
- Knowledge Agent is fully deterministic (regex-based, no LLM calls).
- RepairDB handles ~35% of compiler errors without LLM calls (Tier A exact match), ~25% via heuristics (Tier B), remaining ~40% escalate to LLM (Tier C).
- **Training base model**: Goedel-Prover-V2-8B (`Goedel-LM/Goedel-Prover-V2-8B`). Qwen3-8B architecture, expert-iteration trained with Lean compiler feedback. 83% pass@32 on MiniF2F.

## CI/CD

- `lean_action_ci.yml`: Lean compilation check + docgen on push/PR
- `create-release.yml`: Auto-tags releases when `lean-toolchain` changes
- `update.yml`: Daily Mathlib update check, auto-creates PRs
