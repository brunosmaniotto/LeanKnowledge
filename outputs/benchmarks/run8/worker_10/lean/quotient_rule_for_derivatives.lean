import Mathlib

variable {j k : ℝ → ℝ} {ξ : ℝ} {I : Set ℝ}

-- Pointwise quotient rule at a point ξ
theorem quotient_rule_at (hj : DifferentiableAt ℝ j ξ) (hk : DifferentiableAt ℝ k ξ) (hξ : k ξ ≠ 0) :
    DifferentiableAt ℝ (j / k) ξ ∧ deriv (j / k) ξ = (deriv j ξ * k ξ - j ξ * deriv k ξ) / (k ξ) ^ 2 := by
  constructor
  · exact DifferentiableAt.div hj hk hξ
  · exact deriv_div hj hk hξ

-- Quotient rule on an interval I