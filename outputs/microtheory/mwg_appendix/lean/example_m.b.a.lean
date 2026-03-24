import Mathlib

open Real

-- Part (a): f(x₁, x₂) = x₁ / x₂ is homogeneous of degree zero
theorem Example_M_B_a_part1 (t x₁ x₂ : ℝ) (ht : t ≠ 0) (hx₂ : x₂ ≠ 0) :
    (t * x₁) / (t * x₂) = x₁ / x₂ := by
  rw [mul_div_mul_left _ _ ht]

-- Part (b): f(x₁, x₂) = (x₁ * x₂)^(1/2) is homogeneous of degree one