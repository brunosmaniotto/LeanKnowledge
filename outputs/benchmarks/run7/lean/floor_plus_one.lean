import Mathlib

theorem floor_plus_one (x : ℝ) : ⌊x + 1⌋ = ⌊x⌋ + 1 := by
  have h_lb : (⌊x + 1⌋ : ℝ) ≤ x + 1 := Int.floor_le (x + 1)
  have h_ub : x + 1 < (⌊x + 1⌋ : ℝ) + 1 := Int.lt_floor_add_one (x + 1)
  have h_floor_x : ⌊x⌋ = (⌊x + 1⌋ : ℤ) - 1 := by
    rw [Int.floor_eq_iff]
    constructor
    · push_cast
      linarith
    · push_cast
      linarith
  rw [h_floor_x]
  ring