import Mathlib

-- Proved sub-lemma from the prompt
lemma natAbs_of_coe_gcd (a b : ℤ) : Int.natAbs ↑(Int.gcd a b) = Int.gcd a b := by
  -- The function `Int.gcd a b` returns a natural number `ℕ`.
  -- The goal is to prove that coercing this `ℕ` to a `ℤ` and then taking its
  -- `Int.natAbs` gives back the original `ℕ`.
  -- This is a direct application of the lemma `Int.natAbs_coe_nat`, which states
  -- `Int.natAbs ↑n = n` for any `n : ℕ`.
  -- This lemma is tagged `@[simp]`, so the `simp` tactic can apply it automatically.
  simp

-- Helper lemma to establish that the GCD is non-zero, as suggested by the skeleton.