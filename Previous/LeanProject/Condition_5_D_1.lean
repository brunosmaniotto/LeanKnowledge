import Mathlib.Analysis.Calculus.Deriv.Basic
import Mathlib.Data.Real.Basic

/-- Condition 5.D.1: First-order condition for profit maximization.
    For a given output price p, all profit-maximizing output levels q ≥ 0 
    must satisfy the first-order condition: p ≤ C'(q), with equality if q > 0. -/
theorem profit_max_foc (p : ℝ) (C : ℝ → ℝ) (q : ℝ)
    (h_diff : DifferentiableAt ℝ C q)
    (h_q_nonneg : 0 ≤ q)
    (h_max : ∀ q' ≥ 0, p * q' - C q' ≤ p * q - C q) :
    p ≤ deriv C q ∧ (q > 0 → p = deriv C q) := sorry
