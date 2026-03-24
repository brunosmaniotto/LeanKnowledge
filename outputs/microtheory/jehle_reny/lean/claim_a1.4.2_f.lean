import Mathlib

/-- At t = 0 or t = 1, the strict concavity inequality f(xₜ) > t·f(x₁) + (1-t)·f(x₂)
    cannot hold, because xₜ coincides with an endpoint and both sides are equal. -/
theorem strict_concavity_open_interval_necessary
    (f : ℝ → ℝ) (x₁ x₂ : ℝ) :
    ¬(f x₂ > 0 * f x₁ + (1 - 0) * f x₂) ∧
    ¬(f x₁ > 1 * f x₁ + (1 - 1) * f x₂) := by
  constructor <;> · push_neg; ring_nf; linarith