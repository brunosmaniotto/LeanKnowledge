import Mathlib

open Set

theorem Definite_Integral_of_Function_plus_Constant
    (a b c : ℝ) (f : ℝ → ℝ) (hcont : ContinuousOn f (uIcc a b)) :
    ∫ t in a..b, f t + c = (∫ t in a..b, f t) + c * (b - a) := by
  rw [intervalIntegral.integral_add hcont.intervalIntegrable intervalIntegrable_const,
      intervalIntegral.integral_const, smul_eq_mul, mul_comm]