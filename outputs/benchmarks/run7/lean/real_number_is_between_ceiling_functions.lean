import Mathlib

open Real

theorem ceil_bounds (x : ℝ) : (Int.ceil (x - 1) : ℝ) ≤ x ∧ x ≤ (Int.ceil x : ℝ) := by
  constructor
  · have H := Int.ceil_lt_add_one (x - 1)
    rw [sub_add_cancel] at H
    exact le_of_lt H
  · exact Int.le_ceil x