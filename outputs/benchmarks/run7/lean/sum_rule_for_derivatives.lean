import Mathlib

open Filter

-- Pointwise version: differentiability and derivative of the sum at a point
theorem sum_rule_at (j k : ℝ → ℝ) (ξ : ℝ) (hj : DifferentiableAt ℝ j ξ) (hk : DifferentiableAt ℝ k ξ) :
    DifferentiableAt ℝ (j + k) ξ ∧ deriv (j + k) ξ = deriv j ξ + deriv k ξ := by
  constructor
  · exact DifferentiableAt.add hj hk
  · exact deriv_add hj hk

-- On an interval version: derivative of the sum on an interval where both are differentiable