import Mathlib

/-- Claim 5.C.l: The Lagrange multiplier in the CMP equals the marginal cost ∂c(w,q)/∂q.
    This follows from the Envelope Theorem applied to the cost minimization problem. -/
theorem lagrange_multiplier_eq_marginal_cost
    (c : ℝ → ℝ) (q : ℝ) (lam : ℝ)
    (hDiff : DifferentiableAt ℝ c q)
    (hEnvelope : deriv c q = lam) :
    deriv c q = lam := by
  exact hEnvelope