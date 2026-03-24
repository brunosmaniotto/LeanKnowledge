import Mathlib

open Real Filter Topology

/-- For all values of x for which y₂(x) is continuous, the derivative of E(g₁)
    with respect to x must be zero: ∂E(g₁)/∂x = -y₂(x) + (v₁ - x) · y₂'(x) = 0. -/
theorem Equation_Vickrey3_p31_1
    (y₂ : ℝ → ℝ) (v₁ : ℝ)
    (E : ℝ → ℝ)
    (hE : ∀ x, HasDerivAt E (-y₂ x + (v₁ - x) * deriv y₂ x) x)
    (hopt : ∀ x, deriv E x = 0) :
    ∀ x, -y₂ x + (v₁ - x) * deriv y₂ x = 0 := by
  intro x
  have h1 := (hE x).deriv
  rw [hopt x] at h1
  linarith