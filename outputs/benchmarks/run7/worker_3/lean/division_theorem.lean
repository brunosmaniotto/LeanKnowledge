import Mathlib

-- This lemma proves the existence part of the Division Theorem.
-- It provides a constructive proof by using Lean's built-in integer
-- division (a / b) and remainder (a % b) operators.
lemma division_existence (a b : ℤ) (hb : b ≠ 0) : ∃ q r : ℤ, a = q * b + r ∧ 0 ≤ r ∧ r < |b| := by
  -- We choose the quotient `q` to be `a / b` and the remainder `r` to be `a % b`.
  use a / b, a % b
  -- We now have three goals to prove, corresponding to the `∧` clauses.
  -- The `split_ands` tactic separates them.
  split_ands
  -- 1. Prove `a = (a / b) * b + (a % b)`.
  -- This is the symmetric form of `Int.ediv_add_emod'`.
  · exact (Int.ediv_add_emod' a b).symm
  -- 2. Prove `0 ≤ a % b`.
  -- This is a direct application of `Int.emod_nonneg`.
  · exact Int.emod_nonneg a hb
  -- 3. Prove `a % b < |b|`.
  -- This is a direct application of `Int.emod_lt_abs`.
  · exact Int.emod_lt_abs a hb

-- This lemma proves the uniqueness part of the Division Theorem.
-- It assumes two pairs (q₁, r₁) and (q₂, r₂) satisfy the division property
-- and shows they must be equal.