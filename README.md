# LeanKnowledge

An LLM-powered pipeline that automatically formalizes mathematical theorems from textbooks and papers into verified Lean 4 code, organizing results into a knowledge graph.

## Motivation

Most AI + formal verification work focuses on proving new theorems (AlphaProof, DeepSeek-Prover). Meanwhile, formalizing *known* mathematics — centuries of proven textbook results — remains almost entirely manual (Mathlib). LeanKnowledge looks backwards: it takes existing proofs from mathematical texts and systematically translates them into machine-verified code.

The initial domain is microeconomic theory (Mas-Colell, Whinston, and Green), building toward verification of research papers like Milgrom & Shannon (1994) on monotone comparative statics.

## What It Does

Given a source text (textbook PDF, paper, or theorem statement):

0. **Extract** — reads mathematical claims from PDFs (definitions, theorems, proofs, dependencies)
1. **Prove** — generates a structured natural-language proof with explicit strategy and dependencies
2. **Translate** — converts the NL proof into Lean 4 code with Mathlib imports
3. **Verify** — iterates against the Lean compiler, classifying errors and repairing code
4. **Integrate** — tags verified proofs and inserts them into a knowledge graph

The system operates in two complementary modes: **bottom-up** (formalize textbook chapters sequentially) and **top-down** (start from a paper's main result, trace and resolve its dependency chain). The two modes meet in the middle.

## Current Status

| Component | Status |
|-----------|--------|
| Pipeline (8 agents) | All operational |
| MWG Textbook | Ch 1-23 extracted, ~69 theorems verified |
| Rosetta Stone | Complete: 222k NL-Lean pairs (all of Mathlib) |
| Citation Graph | Built (Semantic Scholar + OpenAlex) |
| Fine-tuning | Data ready, trainer not yet built |

See [ARCHITECTURE.md](ARCHITECTURE.md) for the full system design.

## Quick Start

### Prerequisites

- Python 3.12+ with [uv](https://github.com/astral-sh/uv)
- Lean 4 via [elan](https://github.com/leanprover/elan)
- Claude Code CLI

### Setup

```bash
uv sync                    # Install Python dependencies
lake update && lake build  # Download Mathlib + compile Lean project
```

### Usage

```bash
# Extract theorems from a PDF
leanknowledge extract --pdf FILE --start-page N --end-page N --domain DOMAIN [--source LABEL]

# Formalize next ready item from backlog
leanknowledge next

# Run all ready items
leanknowledge run

# Check backlog status
leanknowledge status

# Single theorem (bypasses backlog)
leanknowledge formalize --name NAME --statement STMT --domain DOMAIN
```

### Rosetta Stone Corpus

```bash
# Generate NL descriptions for a Mathlib module
python3 rosetta_stone/generate.py --module Mathlib.Order.Defs \
  --mathlib-root .lake/packages/mathlib --output rosetta_stone/pairs/output.json

# Batch process all submodules (with resume)
python3 rosetta_stone/generate.py --module Mathlib --mathlib-root .lake/packages/mathlib \
  --all-submodules --resume --pairs-dir rosetta_stone/pairs
```

## Architecture

```
Source PDF/Paper
        |
  Stage 0: Extraction ──→ Router ──→ Backlog (unproved claims)
  (PDF → claims)              |↑            |
        |               Librarian       Feeder (planned)
        ↓                  |↑            |
  Stage 1: Proof       Rosetta Stone   (feeds back to Stage 0)
  (NL structured proof)  (222k pairs)
        |
        ↓
  Stage 2: Translator  ←── Librarian (exact Lean names)
  (NL → Lean 4 code)
        |
        ↓
  Stage 3: Verifier    ←── RepairDB (deterministic fixes)
  (compile-repair loop) ←── Librarian (missing imports)
        |
        ↓
  Stage 4: Knowledge   ──→ Knowledge Tree
  (tag + integrate)    ──→ Training Data
```

See [ARCHITECTURE.md](ARCHITECTURE.md) for detailed agent descriptions, schemas, persistent resources, production tooling, and training plans.

## Existing Landscape

| Effort | Focus | Gap |
|--------|-------|-----|
| Mathlib | Manual formalization of math canon | Manual, slow, no LLM automation |
| DeepSeek-Prover / AlphaProof | Proving new/hard theorems | Forward-looking, not systematic formalization |
| ALA (NeurIPS 2025) | Agentic autoformalization | Benchmarking, not library-building; 52% on graduate theorems |
| FormL4 / PDA (ICLR 2025) | Autoformalization benchmarks | Framework contributions, not knowledge organization |

**Distinctive contribution**: nobody is building a pipeline that systematically formalizes known results and organizes them into a knowledge graph.

## Accuracy Calibration

Current state of the art (honest numbers):

- Fine-tuned LLMs: ~22.5% on graduate-level theorems (Pass@128)
- Agentic systems (ALA): ~52% with compiler feedback
- Formalizing known results with provided proofs should be easier than cold theorem proving, but economic formulations introduce challenges (idiosyncratic notation, non-standard assumptions)

## Tech Stack

- **Python 3.12+** (uv, hatchling) — pipeline orchestration
- **Lean 4 v4.27.0** + Mathlib v4.27.0 — formal verification
- **Claude** (Code CLI / API) — reasoning agents
- **sentence-transformers** — embedding search for Librarian
- **PyMuPDF** — PDF text extraction

## Related Projects

**RobustCheck** (sibling project): empirical verification of statistical results. Together with LeanKnowledge, they form a vision for comprehensive scientific verification — theoretical (formal proofs) and empirical (statistical robustness).
