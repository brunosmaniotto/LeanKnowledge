import Mathlib

open Set Filter Topology

/--
At an interior profit maximum, price equals marginal cost.
If q* > 0 maximizes pq - c(q), then p = c'(q*).
-/
theorem Claim_5C_o
    (c : ℝ → ℝ) (p qstar : ℝ)
    (hq_pos : 0 < qstar)
    (hc_diff : DifferentiableAt ℝ c qstar)
    (hmax : IsLocalMax (fun q => p * q - c q) qstar) :
    p = deriv c qstar := by
  have h2 : HasDerivAt (fun q => p * q - c q) (p - deriv c qstar) qstar := by
    have hp : HasDerivAt (fun q => p * q) p qstar := by
      have := (hasDerivAt_id qstar).const_mul p
      simpa [mul_comm] using this
    exact hp.sub hc_diff.hasDerivAt
  have h3 : p - deriv c qstar = 0 := by
    exact hmax.hasDerivAt_eq_zero h2
  linarith