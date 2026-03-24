import Mathlib

theorem exists_between_rat {a b : ℚ} (h : a < b) : ∃ c : ℚ, a < c ∧ c < b := by
  use (a + b) / 2
  constructor
  · linarith
  · linarith