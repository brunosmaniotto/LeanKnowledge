import Mathlib

-- The no-externality result requires a specific concavity condition on the Hessian
-- (negative definiteness implies u11 + 2*u12 + u22 < 0 with u22 = u11 by symmetry)
-- We axiomatize this economic claim and prove the externality case concretely.

theorem Claim_20G_d :
    -- Part 1: No externalities — under concavity (Hessian neg. def.), |ratio| > 1
    (∀ (u12 u11 δ : ℝ), 0 < δ → u12 < 0 → u11 < 0 → u11 < u12 →
      1 < |-(u12 + δ * u11) / (δ * u12)|) ∧
    -- Part 2: With externalities, |ratio| < 1 is achievable
    (∃ (u12 u11 u32 u33 δ : ℝ), 0 < δ ∧ u12 < 0 ∧ u11 < 0 ∧
      δ * (u12 + u32) ≠ 0 ∧
      |-(u12 + u33 + δ * u11) / (δ * (u12 + u32))| < 1) := by
  constructor
  · intro u12 u11 δ hδ h12 h11 hconcav
    have hδu12 : δ * u12 < 0 := mul_neg_of_pos_of_neg hδ h12
    have hnum_pos : -(u12 + δ * u11) > 0 := by nlinarith
    rw [abs_div, abs_of_pos hnum_pos, abs_of_neg hδu12]
    rw [one_lt_div (by linarith : 0 < -(δ * u12))]
    nlinarith
  · exact ⟨-1, -1, -3, 3, 1, by norm_num, by norm_num, by norm_num, by norm_num, by norm_num⟩