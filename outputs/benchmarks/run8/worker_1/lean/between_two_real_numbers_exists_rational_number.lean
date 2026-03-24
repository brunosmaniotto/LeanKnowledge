import Mathlib

theorem exists_rational_between (a b : ℝ) (h : a < b) : ∃ r : ℚ, a < (r : ℝ) ∧ (r : ℝ) < b := by
  exact exists_rat_btwn h