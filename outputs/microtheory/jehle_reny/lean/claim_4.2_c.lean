import Mathlib
open Topology

/-- The profit-maximising monopoly output q* satisfies p(q*)(1 + 1/ε(q*)) = mc(q*) ≥ 0.
    Since price is non-negative and marginal cost is non-negative, this requires |ε(q*)| ≥ 1.
    Therefore, the monopolist never operates in the inelastic portion of demand. -/
theorem Claim_4_2_c
    (p mc ε : ℝ)
    (hp : p > 0)
    (hmc : mc ≥ 0)
    (hε_neg : ε < 0)
    (h_foc : p * (1 + 1 / ε) = mc) :
    |ε| ≥ 1 := by
  have hε_ne : ε ≠ 0 := hε_neg.ne
  rw [abs_of_neg hε_neg]
  -- Clear the 1/ε denominator: p*(ε+1) = mc*ε
  have h := h_foc
  field_simp [hε_ne] at h
  -- Need: -ε ≥ 1, i.e., ε + 1 ≤ 0
  suffices ε + 1 ≤ 0 by linarith
  by_contra hc
  push_neg at hc
  -- p*(ε+1) > 0 but mc*ε ≤ 0, contradicting the cleared equation
  nlinarith [mul_pos hp hc, mul_nonneg hmc (neg_nonneg.mpr hε_neg.le)]