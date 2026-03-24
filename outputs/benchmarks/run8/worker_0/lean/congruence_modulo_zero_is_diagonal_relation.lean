import Mathlib.Data.Int.ModEq

theorem mod_zero_eq_diagonal (x y : ℤ) : x ≡ y [ZMOD 0] ↔ x = y := by
  rw [Int.ModEq, Int.emod_zero, Int.emod_zero]