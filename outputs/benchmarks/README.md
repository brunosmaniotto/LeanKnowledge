# Benchmark Outputs

These directories contain raw pipeline outputs from benchmark runs against the
ProofWiki corpus (general mathematics, not microeconomic theory).

Each `lean/` subdirectory contains the Lean 4 files produced by the translator.
Files containing `sorry` indicate proofs that the pipeline did not complete
successfully — they are included as-is to allow analysis of failure modes.

See [IMPROVEMENTS.md](../../IMPROVEMENTS.md) for run-by-run results and error
taxonomy.

| Run | Corpus | Success rate | Notes |
|-----|--------|-------------|-------|
| run7 | 1,000 ProofWiki theorems | 96.4% | All-Gemini |
| run8 | 1,000 ProofWiki theorems (disjoint) | 57.1% | DeepSeek + Gemini tiered; harder categories |
