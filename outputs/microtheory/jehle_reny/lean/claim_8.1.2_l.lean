import Mathlib

/-- For unproductive signalling in insurance markets, different risk types must have
different marginal rates of substitution between benefit levels B and premiums p.
The single-crossing property states MRS_l(B,p) < MRS_h(B,p) for all (B,p),
because low-risk consumers need less premium reduction to compensate for
decreased benefits (lower accident probability). -/
theorem Claim_8_1_2_l
    (π_l π_h : ℝ)
    (hπ_pos_l : 0 < π_l) (hπ_pos_h : 0 < π_h)
    (hπ_lt : π_l < π_h)
    (hπ_bound_l : π_l < 1) (hπ_bound_h : π_h < 1)
    (MRS_l MRS_h : ℝ)
    (hMRS_l : MRS_l = π_l / (1 - π_l))
    (hMRS_h : MRS_h = π_h / (1 - π_h))
    : MRS_l < MRS_h := by
  subst hMRS_l; subst hMRS_h
  have h1 : (0 : ℝ) < 1 - π_l := by linarith
  have h2 : (0 : ℝ) < 1 - π_h := by linarith
  rw [div_lt_div_iff₀ h1 h2]
  nlinarith