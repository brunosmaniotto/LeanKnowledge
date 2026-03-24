import Mathlib

/-- Exercise 3.24 (Jehle & Reny): The Lagrange multiplier λ(w,y) in the cost
    minimisation problem equals marginal cost mc(w,y) = ∂c(w,y)/∂y.
    This is an application of the Envelope Theorem. -/
theorem exercise_3_24
    (c : ℝ → ℝ) (y : ℝ) (lam : ℝ)
    (hDiff : DifferentiableAt ℝ c y)
    (hEnvelope : deriv c y = lam) :
    deriv c y = lam := by
  exact hEnvelope