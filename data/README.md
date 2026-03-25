# Data Directory

This directory contains all input data for the LeanKnowledge pipeline. Large files (PDFs, indices) are gitignored and must be placed locally.

## Structure

```
data/
├── mathlib_index.json           # TF-IDF index over ~207K Mathlib declarations (93 MB)
├── naturalproofs_proofwiki.json # ProofWiki corpus for benchmark runs (112 MB)
├── openalex_100/                # Top-100-cited microeconomics papers + citation graph
│   ├── citation_graph.json
│   ├── papers.jsonl
│   └── ranked_papers.json
├── books/                       # Textbook PDFs (input to extraction agent)
│   ├── JEHLE-RENY.pdf
│   ├── MICROECONOMICTHEORY.pdf  # MWG
│   └── ...
├── papers/                      # Research paper PDFs + text extractions
│   ├── *.pdf                    # Core papers (Vickrey, Nash, Myerson, etc.)
│   ├── arxiv_2026/              # Recent arXiv papers
│   ├── arxiv_deps/              # Dependency papers for arXiv extractions
│   ├── decision_theory/         # Decision theory corpus
│   ├── handbooks/               # Handbook of Game Theory, Math Econ, etc.
│   ├── chunks/                  # Chunked text for LLM context windows
│   └── text/                    # Full-text extractions
└── extractions/                 # Structured extraction outputs (committed)
    ├── arrow_debreu_part02_definitive.json
    ├── ch05_part1_extraction.json
    ├── ch09_part2_extraction.json
    ├── definitive_extraction.json
    ├── myerson_1986_multistage_part02_definitive.json
    └── merged_identifiers.json
```

## Gitignored vs committed

- **Committed**: `extractions/` (small JSON files, pipeline artifacts)
- **Gitignored**: Everything else (large binary files, copyrighted PDFs, regenerable indices)

## Obtaining the data

**Mathlib index**: Regenerate with `python scripts/build_mathlib_index.py`

**ProofWiki corpus**: Download with `python scripts/download_proofwiki.py`

**OpenAlex data**: Fetch with `python scripts/fetch_openalex.py --min-citations 100`

**Books and papers**: Place PDF files manually. The pipeline's extraction agent (Agent 1) reads these via PyMuPDF with Google Document AI fallback.
