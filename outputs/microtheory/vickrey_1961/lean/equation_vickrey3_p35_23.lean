import Mathlib

open Real

/-- Equation (22) can be rewritten as y₂^(r₂ - r₁) = A · (x - r₂)^r₁ · (x - r₁)^(-r₂),
    converting the division form to negative-exponent form. -/
theorem equation_vickrey3_p35_23
    (A x r₁ r₂ y₂ : ℝ)
    (hx_r₁ : 0 ≤ x - r₁)
    (h_eq22 : y₂ ^ (r₂ - r₁) = A * (x - r₂) ^ r₁ / (x - r₁) ^ r₂) :
    y₂ ^ (r₂ - r₁) = A * (x - r₂) ^ r₁ * (x - r₁) ^ (-r₂) := by
  rw [rpow_neg hx_r₁, ← div_eq_mul_inv]
  exact h_eq22