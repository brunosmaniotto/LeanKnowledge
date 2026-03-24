import Mathlib

/-- The marginal rate of substitution of good 2 for good 1 (MRS₁₂)
    when X = ℝ²₊, defined as the absolute value of the slope of the
    indifference curve at point x. By the implicit function theorem,
    this equals |∂u/∂x₁ / ∂u/∂x₂|. -/
noncomputable def MRS₁₂
    (u : (Fin 2 → ℝ) → ℝ) (x : Fin 2 → ℝ) : ℝ :=
  |fderiv ℝ u x (Pi.single 0 1) / fderiv ℝ u x (Pi.single 1 1)|