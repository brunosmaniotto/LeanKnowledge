# Rosetta Stone -- Project Status

## What Is This?

The Rosetta Stone is a large-scale corpus of (natural language proof, Lean 4 proof) pairs extracted from Mathlib. Its purpose is to serve as training data for a fine-tuned Translator model that will replace Claude in Stage 3 (Translation) of the LeanKnowledge pipeline.

The pipeline currently uses Claude for translating natural-language proofs into Lean 4 code. A fine-tuned model trained on tens of thousands of verified (NL, Lean) pairs should perform this translation more reliably, faster, and at lower cost.

## What We Built

### 1. Lean Declaration Parser (`rosetta_stone/generate.py`)

A regex-based parser that extracts declarations from Lean 4 source files. It handles:

- **Declaration types**: `theorem`, `lemma`, `def`, `abbrev`, `class`, `instance`, `structure`
- **Filtering**: Skips deprecated entries, aliases, macros, meta definitions, attribute assignments
- **Module resolution**: Handles both single-file modules (`Mathlib.Order.Basic` -> one `.lean` file) and directory modules (`Mathlib.Order.Defs` -> multiple `.lean` files)

### 2. Two-Phase NL Generation

Each declaration gets a natural language description via one of two paths:

**Mechanical generation (57% of declarations)** -- no API calls needed:
- Class/structure definitions: described from doc comments
- Term-mode one-liners: "Directly applies `Preorder.le_refl`"
- Single-tactic proofs (`by rfl`, `by simp`, `by grind`, `by exact X`)
- Simple 2-3 line tactic proofs using basic tactics
- Instance `where` blocks

**Claude generation (43% of declarations)** -- sends batches of 8 to `claude -p`:
- Multi-step tactic proofs
- Proofs using case splits, induction, contradiction
- Complex term-mode proofs
- Anything the mechanical generator can't confidently describe

This optimization cuts total processing time from ~63 hours to ~27 hours for all of Mathlib.

### 3. System Prompt (`prompts/rosetta_stone.md`)

Instructs Claude to produce structured JSON for each declaration:
- Plain-language theorem statement
- Proof strategy (direct, contradiction, induction, cases, definition)
- Step-by-step reasoning
- Dependencies on other theorems
- Complexity assessment (trivial/simple/moderate/complex)
- Connections to microeconomic theory where applicable

### 4. Output Schema

Each pair follows the `RosettaPair` Pydantic model:

```json
{
  "id": "Mathlib.Order.Defs.PartialOrder.le_refl",
  "source": "mathlib",
  "mathlib_module": "Mathlib.Order.Defs.PartialOrder",
  "mathlib_name": "le_refl",
  "lean_code": "@[refl, simp] lemma le_refl : ∀ a : α, a ≤ a := Preorder.le_refl",
  "nl_proof": {
    "statement": "For any element a in a preorder, a ≤ a.",
    "strategy": "direct",
    "assumptions": ["α is a preorder"],
    "steps": ["Apply the reflexivity axiom from the Preorder class."],
    "dependencies": ["Preorder.le_refl"]
  },
  "metadata": {
    "domain": "order_theory",
    "tags": ["order", "preorder", "partial_order"],
    "lean_tactics_used": [],
    "complexity": "trivial",
    "related_economics_concepts": [
      "Reflexivity of weak preference: any bundle is weakly preferred to itself."
    ]
  }
}
```

## Current State

### Corpus Statistics (as of 2026-02-16)

| Metric | Count |
|--------|-------|
| **Files processed** | 1,542 / 7,516 |
| **Total pairs** | 53,361 / ~227,000 |
| **Progress** | ~20% of Mathlib |
| **Trivial** | 37,072 |
| **Simple** | 11,056 |
| **Moderate** | 4,107 |
| **Complex** | 1,126 |
| **With economics concepts** | 5,380 |

### What Has Been Processed

- **Mathlib.Order** (complete): 290 files, 15,203 pairs -- order theory, the mathematical foundation of preference relations
- **Partial Mathlib**: ~1,250 additional files from other Mathlib subdirectories (Algebra, Analysis, CategoryTheory, Combinatorics, etc.)

### What Remains

~6,000 more Mathlib files (~174,000 declarations). Estimated ~20 more hours of processing.

## How to Resume

The generator supports `--resume` which skips any file that already has output. To continue where we left off:

```bash
cd /path/to/LeanKnowledge

python3 rosetta_stone/generate.py \
  --module Mathlib \
  --mathlib-root .lake/packages/mathlib \
  --all-submodules \
  --resume \
  --pairs-dir rosetta_stone/pairs
```

This will:
1. Scan all 7,516 `.lean` files under `Mathlib/`
2. Skip the ~1,542 files that already have output in `rosetta_stone/pairs/`
3. Process the remaining ~6,000 files
4. Rebuild `index.json` when done

The process is safe to interrupt at any time (Ctrl+C). Each file is written atomically -- partial files won't be created.

### Other Useful Commands

```bash
# Extract-only mode (no Claude calls, just test the parser)
python3 rosetta_stone/generate.py \
  --module Mathlib.SomeModule \
  --mathlib-root .lake/packages/mathlib \
  --output /dev/null --extract-only

# Rebuild the index from existing pairs
python3 rosetta_stone/generate.py --build-index --pairs-dir rosetta_stone/pairs

# Process a single module
python3 rosetta_stone/generate.py \
  --module Mathlib.Topology.Basic \
  --mathlib-root .lake/packages/mathlib \
  --output rosetta_stone/pairs/mathlib_topology_basic.json
```

## Architecture Notes

### Why `claude -p` instead of the Anthropic API?

The project uses the Claude Code CLI (`claude -p`) for all LLM calls, consistent with the rest of the LeanKnowledge pipeline (`src/leanknowledge/claude_client.py`). This keeps authentication simple (uses the user's Claude subscription) and avoids needing an API key.

One caveat: when running from within a Claude Code session, the `CLAUDECODE` environment variable must be unset to avoid the nested-session error. The script handles this automatically.

### Why Not Just Use Doc Comments?

Mathlib doc comments are terse one-liners (e.g., "The relation ≤ on a preorder is reflexive."). The Rosetta Stone needs structured proofs with strategy, steps, dependencies, and complexity -- the kind of data a Translator model needs to learn the mapping from NL reasoning to Lean tactics.

### File Layout

```
rosetta_stone/
├── STATUS.md                  # This file
├── README.md                  # Schema docs and usage reference
├── generate.py                # Main script (~900 lines)
├── pairs/
│   ├── index.json             # Master index (rebuilt on completion)
│   ├── mathlib_order_*.json   # Order theory pairs (complete)
│   ├── mathlib_algebra_*.json # Algebra pairs (partial)
│   ├── ...                    # ~1,542 files total so far
```

## Next Steps

1. **Finish Mathlib processing** -- resume the run to completion (~20 more hours)
2. **Rebuild index** -- `--build-index` to get final statistics
3. **Quality audit** -- spot-check moderate/complex pairs for accuracy
4. **Fine-tuning** -- use the corpus to train a Translator model (likely on the `training_data/` pipeline)
5. **Integration** -- swap the fine-tuned model into Stage 3 of the LeanKnowledge pipeline
