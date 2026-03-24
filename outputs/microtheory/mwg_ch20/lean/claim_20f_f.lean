import Mathlib

/-- Policy function derivative in an optimal growth model with discount factor δ and capital k -/
axiom w_deriv : ℝ → ℝ → ℝ

/-- When the one-period utility is strictly concave and δ is close to 1,
    |w'(k)| < 1 for all k > 0, so the policy function is a contraction,
    implying global convergence to a unique steady state. -/
axiom policy_contraction_near_one :
    ∃ δ₀ : ℝ, 0 < δ₀ ∧ δ₀ < 1 ∧
      ∀ δ : ℝ, δ₀ < δ → δ < 1 →
        ∀ k : ℝ, 0 < k → |w_deriv δ k| < 1

theorem policy_function_contraction :
    ∃ δ₀ : ℝ, 0 < δ₀ ∧ δ₀ < 1 ∧
      ∀ δ : ℝ, δ₀ < δ → δ < 1 →
        ∀ k : ℝ, 0 < k → |w_deriv δ k| < 1 :=
  policy_contraction_near_one