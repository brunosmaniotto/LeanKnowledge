import Mathlib

open Real

theorem cot_half_int_mul_pi (n : ℤ) : Real.cot ((n + 1/2) * π) = 0 := by
  have H : (n + 1/2) * π = (n : ℝ) * π + π / 2 := by
    push_cast
    ring
  rw [H, Real.cot_eq_cos_div_sin, Real.cos_add, Real.sin_add]
  rw [show (n : ℝ) * π = (n : ℤ) * π by simp]
  rw [Real.cos_int_mul_pi n, Real.sin_int_mul_pi n]
  rw [Real.cos_pi_div_two, Real.sin_pi_div_two]
  simp