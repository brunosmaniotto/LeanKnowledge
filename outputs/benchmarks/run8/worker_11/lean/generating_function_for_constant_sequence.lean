import Mathlib

theorem generating_function_constant (r : ℝ) (z : ℝ) (h : abs z < 1) :
    HasSum (fun n : ℕ ↦ r * z ^ n) (r / (1 - z)) := by
  have h_geo : HasSum (fun n : ℕ ↦ z ^ n) ((1 : ℝ) - z)⁻¹ :=
    hasSum_geometric_of_abs_lt_one h
  have h_sum : HasSum (fun n : ℕ ↦ r * z ^ n) (r * ((1 : ℝ) - z)⁻¹) :=
    h_geo.mul_left r
  -- Simplify r * (1 - z)⁻¹ to r/(1 - z) (definitional in Lean)
  simpa [div_eq_mul_inv] using h_sum