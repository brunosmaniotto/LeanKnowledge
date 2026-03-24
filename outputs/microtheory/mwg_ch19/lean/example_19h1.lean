import Mathlib

open Real

theorem Example_19H1 :
    (1 : ℝ) / 2 < 1 / Real.sqrt 2 := by
  have h2 : (0 : ℝ) < 2 := by norm_num
  have hsqrt_pos : (0 : ℝ) < Real.sqrt 2 := Real.sqrt_pos.mpr h2
  have hsq : Real.sqrt 2 * Real.sqrt 2 = 2 := Real.mul_self_sqrt (le_of_lt h2)
  rw [div_lt_div_iff₀ h2 hsqrt_pos]
  nlinarith [sq_nonneg (Real.sqrt 2 - 1)]