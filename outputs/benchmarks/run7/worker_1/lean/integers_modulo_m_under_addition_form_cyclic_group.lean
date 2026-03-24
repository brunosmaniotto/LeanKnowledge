import Mathlib

-- This sub-lemma establishes that if a natural number `m` is at least 1,
-- it is non-zero. This is captured by the `NeZero m` typeclass, which is
-- a required instance for `ZMod m` to be a `Fintype` (a finite type).
lemma neZero_of_one_le {m : ℕ} (hm : 1 ≤ m) : NeZero m := by
  -- The typeclass `NeZero m` requires a proof of `m ≠ 0`.
  -- We can use the `constructor` tactic to provide this proof.
  constructor
  -- The goal is now to prove `m ≠ 0`.
  -- Mathlib has a lemma `Nat.pos_iff_ne_zero` which states `0 < n ↔ n ≠ 0`.
  -- We can use this to change our goal to `0 < m`.
  rw [← Nat.pos_iff_ne_zero]
  -- The goal is now `0 < m`.
  -- For natural numbers, `0 < m` is equivalent to `1 ≤ m`.
  -- Our hypothesis `hm` is exactly this, so we can use it to close the goal.
  exact hm

-- This sub-lemma states that the element 1 generates the additive group of integers modulo m.
-- This is a known result in Mathlib.