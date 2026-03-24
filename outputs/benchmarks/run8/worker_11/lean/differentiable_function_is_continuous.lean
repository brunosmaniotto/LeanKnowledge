import Mathlib

theorem differentiable_implies_continuous_within_at {f : ℝ → ℝ} {I : Set ℝ} {x₀ : ℝ}
    (h : DifferentiableWithinAt ℝ f I x₀) : ContinuousWithinAt f I x₀ :=
  h.continuousWithinAt