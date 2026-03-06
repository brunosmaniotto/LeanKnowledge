# LeanKnowledge

Multi-agent pipeline that reads mathematical texts and produces verified Lean 4 proofs.

## Architecture

Six agents in sequence: PDF Extraction → Claim Extraction → Triage → Librarian → Proof Structurer → Translator (with compiler feedback loop). See [`Current/ARCHITECTURE.md`](Current/ARCHITECTURE.md) for the full design.

## Quick Start

```bash
# Install
pip install -e "Current/[test]"

# Run tests
pytest Current/tests/ -q

# ProofWiki pipeline
python Current/scripts/download_proofwiki.py --output data/proofwiki.json --summary
python Current/scripts/run_proofwiki.py --data data/proofwiki.json --lean-project ~/lean-project --max 10
```

## Repository Layout

- **`Current/`** — Active codebase
- **`Previous/`** — Old codebase (reference material)

## Requirements

- Python 3.12+
- Lean 4 + Mathlib (via elan)
- API keys: `ANTHROPIC_API_KEY`, `DEEPSEEK_API_KEY`
