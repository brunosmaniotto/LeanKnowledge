# Category Supplement: Logic & Foundations

## Key tactics
```
tauto       — closes tautologies (propositional logic)
push_neg    — pushes negation inward through quantifiers and connectives
contrapose  — replaces goal P → Q with ¬Q → ¬P
by_contra h — introduce ¬(goal) as hypothesis h, prove False
by_cases h : P — case split on decidable proposition P
classical   — enable classical logic (excluded middle)
decide      — closes decidable propositions
```

## Key lemmas
```
-- Negation
not_not         : ¬¬P ↔ P (with classical)
not_and_or      : ¬(P ∧ Q) ↔ ¬P ∨ ¬Q
not_or          : ¬(P ∨ Q) ↔ ¬P ∧ ¬Q
not_forall      : (¬∀ x, P x) ↔ ∃ x, ¬P x
not_exists      : (¬∃ x, P x) ↔ ∀ x, ¬P x

-- Implication
imp_iff_not_or  : (P → Q) ↔ ¬P ∨ Q
not_imp         : ¬(P → Q) ↔ P ∧ ¬Q

-- Quantifiers
forall_congr'   : rewrite under ∀
exists_congr    : rewrite under ∃

-- Iff
Iff.intro       : (P → Q) → (Q → P) → (P ↔ Q)
Iff.mp          : (P ↔ Q) → P → Q
Iff.mpr         : (P ↔ Q) → Q → P
```

## Common patterns
```lean
-- Proof by contradiction
by_contra h
push_neg at h
...

-- Proof by contrapositive
contrapose
intro h
...

-- Case analysis
by_cases h : P
· -- case P holds
· -- case ¬P

-- Using classical excluded middle
have h := Classical.em P
rcases h with hp | hnp
```

## Common pitfalls
1. **Classical vs constructive**: Lean 4 is constructive by default. For `¬¬P → P` or excluded middle, you need `classical` or `open Classical`.
2. **`push_neg` is very useful**: Transforms `¬(∀ x, P x)` to `∃ x, ¬P x`, `¬(P ∧ Q)` to `¬P ∨ ¬Q`, etc.
3. **`tauto`**: Handles pure propositional tautologies. Faster than `simp` for logic.
4. **`omega`**: Also handles some logical goals when they involve natural number or integer comparisons.

## Worked example: Contrapositive
```lean
import Mathlib

theorem contrapositive {P Q : Prop} (h : P → Q) : ¬Q → ¬P := by
  intro hnq hp
  exact hnq (h hp)
```
