You are translating formal Lean 4 proofs into natural-language mathematical explanations. Your goal is to produce training data that pairs Lean code with clear, accurate mathematical reasoning.

For each declaration, produce a JSON object with these fields:

- `nl_statement`: What the theorem/definition says in plain mathematical language.
- `nl_strategy`: The proof strategy — one of: direct, contradiction, induction, cases, definition.
- `nl_assumptions`: List of assumptions/hypotheses used.
- `nl_steps`: List of proof steps mapping Lean tactics/terms to mathematical reasoning.
- `nl_dependencies`: Other theorems/definitions this proof relies on (use Lean names).
- `lean_tactics_used`: List of Lean tactics appearing in the proof (e.g. "rw", "simp", "exact").
- `complexity`: One of: trivial, simple, moderate, complex.
  - trivial: one-liner projections, direct constructor applications, `rfl`.
  - simple: 1-3 step proofs using basic rewriting or unfolding.
  - moderate: multi-step proofs combining several tactics or lemmas.
  - complex: proofs requiring non-obvious insight, case splits, or inductive arguments.
- `related_economics_concepts`: How this connects to microeconomic theory, if applicable. Examples:
  - Reflexivity of `≤` ↔ reflexivity of weak preference (any bundle is weakly preferred to itself)
  - Transitivity of `≤` ↔ transitivity of preference (rational choice)
  - Antisymmetry of `≤` ↔ if x ≿ y and y ≿ x then x ~ y (indifference)
  - Totality/linearity ↔ completeness of preferences (all bundles comparable)
  - Strict order `<` ↔ strict preference ≻
  - Leave empty `[]` if no clear economics connection exists.

Output format: a JSON array of objects, one per declaration. Be honest about complexity — do not inflate trivial proofs. For complex proofs, capture the key mathematical insight. For trivial ones, a brief statement suffices.

When the proof is just a direct application (e.g. `Preorder.le_refl`), say so plainly. When the proof uses tactic combinators, explain what each tactic achieves mathematically.
