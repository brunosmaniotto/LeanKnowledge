import Mathlib

-- This sub-lemma shows that an integer d > 1 is not zero, 1, or -1.
-- These are the conditions for not being a unit or zero.
lemma gt_one_implies_not_unit_or_zero {d : ℤ} (hd : d > 1) : d ≠ 0 ∧ d ≠ 1 ∧ d ≠ -1 := by
  -- This follows directly from the properties of integer inequalities.
  constructor
  · linarith -- d > 1 implies d ≠ 0
  · constructor
    · linarith -- d > 1 implies d ≠ 1
    · linarith -- d > 1 implies d ≠ -1

-- This sub-lemma states that any integer that is not 0, 1, or -1 must have a prime factor.