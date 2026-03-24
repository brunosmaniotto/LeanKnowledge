import Mathlib

-- This file demonstrates how to prove Euler's theorem for integers by assembling
-- a proof from smaller, individually proven lemmas.

-- Sub-lemma 1: Convert integer coprime to natural coprime.
-- This lemma connects the concept of coprimality for integers (`Int.gcd a m = 1`)
-- to coprimality for natural numbers (`Nat.Coprime`), which is used in the `ZMod`
-- version of the theorem.
lemma coprime_int_to_nat (a m : ℤ) (h : a.gcd m = 1) : Nat.Coprime a.natAbs m.natAbs := by
  -- The goal is `Nat.Coprime a.natAbs m.natAbs`.
  -- By `Nat.coprime_iff_gcd_eq_one`, this is equivalent to `Nat.gcd a.natAbs m.natAbs = 1`.
  rw [Nat.coprime_iff_gcd_eq_one]
  -- The hypothesis `h` is `a.gcd m = 1`.
  -- By definition, `Int.gcd a m` is `Nat.gcd a.natAbs m.natAbs`.
  -- So `h` is exactly `Nat.gcd a.natAbs m.natAbs = 1`, which is our goal.
  exact h

--