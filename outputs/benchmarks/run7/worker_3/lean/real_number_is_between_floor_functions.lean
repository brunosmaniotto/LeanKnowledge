import Mathlib

open Int

theorem floor_inequalities (x : ℝ) : (⌊x⌋ : ℝ) ≤ x ∧ x < (⌊x + 1⌋ : ℝ) := by
  constructor
  · exact floor_le x
  · rw [floor_add_one, cast_add, cast_one]
    exact lt_floor_add_one x