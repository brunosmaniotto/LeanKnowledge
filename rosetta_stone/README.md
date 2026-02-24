# Rosetta Stone

A curated corpus of (natural language proof, Lean 4 proof) pairs for training a fine-tuned Translator model.

## Purpose

The LeanKnowledge pipeline uses Claude for all agents, including translation from natural-language proofs to Lean 4. The Rosetta Stone seeds training data from Mathlib's order theory and relation theory modules -- the mathematical foundations of microeconomic preference theory.

## Schema

Each pair in the corpus follows this structure:

```json
{
  "id": "Mathlib.Order.Defs.le_refl",
  "source": "mathlib",
  "mathlib_module": "Mathlib.Order.Defs",
  "mathlib_name": "le_refl",
  "lean_code": "@[refl, simp] lemma le_refl : ...",
  "nl_proof": {
    "statement": "For any element a in a preorder, a <= a.",
    "strategy": "direct",
    "assumptions": ["Preorder alpha"],
    "steps": ["Apply the reflexivity axiom from the Preorder class."],
    "dependencies": ["Preorder.le_refl"]
  },
  "metadata": {
    "domain": "order_theory",
    "tags": ["order", "preorder", "partial_order"],
    "lean_tactics_used": [],
    "complexity": "trivial",
    "related_economics_concepts": [
      "Reflexivity of weak preference: any consumption bundle is weakly preferred to itself."
    ]
  }
}
```

### Fields

| Field | Type | Description |
|-------|------|-------------|
| `id` | string | Unique identifier: `{module}.{lean_name}` |
| `source` | `"mathlib"` or `"pipeline"` | Where the Lean code came from |
| `mathlib_module` | string | Lean module path |
| `mathlib_name` | string | Declaration name in Lean |
| `lean_code` | string | Full Lean 4 source code |
| `nl_proof.statement` | string | Plain-language theorem statement |
| `nl_proof.strategy` | string | Proof method: direct, contradiction, induction, cases, definition |
| `nl_proof.assumptions` | list[str] | Hypotheses used |
| `nl_proof.steps` | list[str] | Step-by-step reasoning |
| `nl_proof.dependencies` | list[str] | Lean names of referenced lemmas |
| `metadata.complexity` | string | trivial, simple, moderate, or complex |
| `metadata.lean_tactics_used` | list[str] | Tactics from the proof |
| `metadata.related_economics_concepts` | list[str] | Connections to microeconomics |

## Directory Structure

```
rosetta_stone/
├── README.md                          # This file
├── generate.py                        # Extraction + NL generation script
├── pairs/
│   ├── mathlib_order_defs.json        # Pairs from Mathlib.Order.Defs
│   ├── mathlib_order_relclasses.json  # Pairs from Mathlib.Order.RelClasses
│   └── index.json                     # Master index of all pairs
```

## Usage

### Extract and generate pairs for a module

```bash
python rosetta_stone/generate.py \
  --module Mathlib.Order.Defs \
  --mathlib-root .lake/packages/mathlib \
  --output rosetta_stone/pairs/mathlib_order_defs.json
```

### Extract only (no Claude calls)

```bash
python rosetta_stone/generate.py \
  --module Mathlib.Order.Defs \
  --mathlib-root .lake/packages/mathlib \
  --output /dev/null \
  --extract-only
```

### Rebuild the index

```bash
python rosetta_stone/generate.py --build-index --pairs-dir rosetta_stone/pairs
```

## Source Modules

| Module | Description | Economics Connection |
|--------|-------------|---------------------|
| `Mathlib.Order.Defs` | Preorders, partial orders, linear orders | Preference relations, completeness, antisymmetry |
| `Mathlib.Order.RelClasses` | Unbundled relation classes, well-foundedness | Relation properties, strict preferences, well-orders |
