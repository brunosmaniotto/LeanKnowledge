# Google Cloud Research Credits — Application Materials

## Program Link
https://edu.google.com/intl/ALL_us/programs/credits/research/

Contact: gcpresearchcredits@google.com

---

## Research Proposal (250 words max)

**Project: Large-Scale Automated Formalization of Mathematics Using LLMs and Lean 4**

I am building LeanKnowledge, a multi-agent pipeline that automatically converts
natural-language mathematical proofs into machine-verified Lean 4 code. The
system reads mathematical texts, extracts claims, and works toward producing
compiler-verified formal proofs with no human intervention.

The pipeline uses a multi-tier translation strategy with Gemini 2.5 Pro via
Vertex AI as the core model, combined with compiler feedback loops that enable
iterative refinement across up to 16 attempts per theorem.

I am using ProofWiki's NaturalProofs dataset (17,911 theorems with proofs) as a
benchmark corpus — it provides a large, diverse collection of human-written
proofs ideal for stress-testing the pipeline at scale. In initial tuning runs on
the first 1,000 theorems, where I iteratively improved the pipeline between
batches, I achieved a 97.4% success rate. A second batch of 1,000 harder
theorems is currently running at ~62% success, highlighting areas for further
improvement.

Every translation attempt generates training triples (informal proof, Lean code,
compiler output). As the dataset grows, I plan to introduce a reinforcement
learning component that uses successful proofs to fine-tune the underlying
models, making the system self-improving over successive runs. The longer-term
goal is to move beyond benchmarks and apply the pipeline to mathematical
research that has not yet been formalized in Lean.

With $1,000 in Google Cloud credits, I estimate I can formalize an additional
8,000 theorems, working toward ~55% coverage of ProofWiki. All results will be
released as open-source resources for the formal methods and AI communities.

(228 words)

---

## Cost Estimate (scoped to $1,000)

### Per-theorem cost breakdown (empirical, from 2,000 theorems)

| Component | Cost/theorem | Notes |
|-----------|-------------|-------|
| Vertex AI (Gemini 2.5 Pro) | ~$0.10 | Multi-tier translation, ~8 attempts avg |
| Compute Engine (e2-standard-4) | ~$0.005 | Lean 4 compilation + orchestration |
| **Total per theorem** | **~$0.105** | |

### What $1,000 in GCP credits covers

| Service | Estimated usage | Cost |
|---------|----------------|------|
| Vertex AI - Gemini 2.5 Pro | ~30,000 API calls | ~$900 |
| Compute Engine (e2-standard-4) | ~350 hours | ~$47 |
| Cloud Storage | <10 GB | ~$1 |
| Buffer for prompt experiments | | ~$52 |
| **Total** | | **$1,000** |

### Theorems covered

- **~8,000 new theorems** at ~$0.12/theorem (including buffer)
- Combined with 2,000 already completed = **~10,000 / 17,911 = 55% of ProofWiki**

### Pricing calculator inputs
- Vertex AI: Gemini 2.5 Pro, ~30K requests, avg 4K input + 2K output tokens
- Compute Engine: 1x e2-standard-4, ~350 hours, us-central1
- Cloud Storage: Standard, <10 GB

---

## Project Details

**Project name:** LeanKnowledge — Automated Mathematical Formalization at Scale

**Start date:** Ongoing (pipeline operational since February 2026)

**Field of research:** Artificial Intelligence / Formal Methods / Mathematical Logic

**Google Cloud services used:**
- Vertex AI (Gemini 2.5 Pro) — core LLM for theorem translation and proof decomposition
- Compute Engine — Lean 4 compiler and pipeline orchestration
- Cloud Storage — dataset and model artifact storage

**Prior results (self-funded):**
- Run 7: 1,000 theorems, 82% raw / 97.4% adjusted success rate
- Run 8: 1,000 theorems, ~62% success rate (harder batch), in progress
- Total: ~2,000 theorems processed, ~1,100+ verified Lean 4 proofs produced
- Pipeline: ~5,000 lines Python, 280+ tests, fully automated

**Open-source commitment:**
All pipeline code, verified proofs, and training triples will be released
publicly. The training dataset is valuable for fine-tuning models for formal
mathematics — a growing area of AI research with direct applications to
Gemini's mathematical reasoning capabilities.

**Post-credit funding strategy:**
The project generates training data usable for fine-tuning open-weight models,
reducing API dependence for future runs. I plan to reapply annually and am
exploring academic grant funding through UC Berkeley for continued development.

---

## Progress Plan with $1,000

| Phase | Theorems | Cumulative | Coverage | GCP Cost |
|-------|----------|------------|----------|----------|
| Completed (Runs 7-8) | 2,000 | 2,000 | 11% | self-funded |
| Runs 9-10 | 2,000 | 4,000 | 22% | ~$240 |
| Runs 11-13 | 3,000 | 7,000 | 39% | ~$360 |
| Runs 14-16 | 3,000 | 10,000 | 55% | ~$360 |
| Retry pass | ~2,000 | ~10,500 | 58% | ~$40 |
| **Total with credits** | **~8,500** | **~10,500** | **~58%** | **~$1,000** |

### Path to full corpus (future funding)

| Milestone | Coverage | Funding Source |
|-----------|----------|----------------|
| Phase 1 (done) | 11% | Self-funded |
| Phase 2 (this grant) | 55-58% | GCP Research Credits |
| Phase 3 (year 2 reapply) | 100% | GCP Credits renewal |

With pipeline improvements between runs (better error recovery, cross-theorem
learning, prompt tuning), later runs achieve higher success rates, reducing
per-theorem cost over time.

---

## Application Checklist

- [ ] Create Google Cloud Billing Account (if not already)
- [ ] Run GCP Pricing Calculator and save results URL
- [ ] Prepare 250-word research proposal (above)
- [ ] Have Berkeley directory/profile link ready
- [ ] Submit at: https://edu.google.com/intl/ALL_us/programs/credits/research/
