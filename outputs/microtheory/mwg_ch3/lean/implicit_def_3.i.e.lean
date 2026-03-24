import Mathlib

open MeasureTheory

/-- The Area Variation (AV) measure of welfare change, defined as the integral
of Walrasian demand for good 1 over the price interval [p₁¹, p₁⁰]. -/
noncomputable def areaVariation
    (x₁ : ℝ → ℝ)  -- Walrasian demand for good 1 as a function of p₁ (with p₋₁ and w fixed)
    (p₁_new p₁_old : ℝ) : ℝ :=
  ∫ p₁ in p₁_new..p₁_old, x₁ p₁