import Mathlib

/-- Two-step profit maximization: if y* > 0 maximizes π(y) = p·y − c(y),
    then p = c'(y*) (FOC) and c''(y*) ≥ 0 (SOC). -/
theorem Claim_3_5_f
    (c : ℝ → ℝ) (p ystar dc : ℝ)
    (hystar_pos : ystar > 0)
    (hc : HasDerivAt c dc ystar)
    -- FOC: π'(y*) = 0
    (hfoc : HasDerivAt (fun y => p * y - c y) 0 ystar)
    -- SOC: −c''(y*) ≤ 0
    (hsoc : -(deriv (deriv c) ystar) ≤ 0) :
    p = dc ∧ deriv (deriv c) ystar ≥ 0 := by
  constructor
  · -- Compute π'(y*) = p − c'(y*), then π'(y*) = 0 gives p = c'(y*)
    have hlin : HasDerivAt (fun y => p * y) p ystar := by
      simpa using (hasDerivAt_id ystar).const_mul p
    have hprofit : HasDerivAt (fun y => p * y - c y) (p - dc) ystar :=
      hlin.sub hc
    have h1 := hfoc.deriv
    have h2 := hprofit.deriv
    linarith
  · -- −c''(y*) ≤ 0 implies c''(y*) ≥ 0
    linarith