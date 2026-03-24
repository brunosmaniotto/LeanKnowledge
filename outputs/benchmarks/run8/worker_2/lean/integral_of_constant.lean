import Mathlib

theorem integral_const_mul (c : ℝ) (f : ℝ → ℝ) (a b : ℝ) :
    ∫ x in a..b, c * f x = c * ∫ x in a..b, f x :=
  intervalIntegral.integral_const_mul c f