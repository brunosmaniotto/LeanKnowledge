import Mathlib
open Real

theorem Gamma_three : Gamma 3 = 2 := by
  calc
    Gamma 3 = Gamma (2 + 1) := by norm_num
    _ = (2 : ℝ) * Gamma 2 := by rw [Gamma_add_one (show (2 : ℝ) ≠ 0 by norm_num)]
    _ = (2 : ℝ) * 1 := by rw [Gamma_two]
    _ = 2 := by norm_num