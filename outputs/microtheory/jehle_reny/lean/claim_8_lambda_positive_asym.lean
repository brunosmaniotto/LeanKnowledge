import Mathlib

/-- In the optimal high-effort contract under moral hazard (MWG Ch. 8),
    the Lagrange multiplier λ on the participation constraint is strictly positive.
    The FOC gives f(l) = λ + β·g(l), where f(l) = 1/u'(w_l) > 0 and
    g(l) = 1 - π_l(eL)/π_l(eH) takes both signs by MLRP. -/
theorem Claim_8_lambda_positive_asym
    {L : Type*}
    (f : L → ℝ) (hf : ∀ l, 0 < f l)
    (g : L → ℝ)
    (lam beta : ℝ) (hbeta : beta ≠ 0)
    (hg_pos : ∃ l, 0 < g l)
    (hg_neg : ∃ l, g l < 0)
    (hFOC : ∀ l, f l = lam + beta * g l) :
    0 < lam := by
  by_contra hlam
  push_neg at hlam
  by_cases hbp : 0 < beta
  · obtain ⟨l, hl⟩ := hg_neg
    have hfl := hf l
    rw [hFOC l] at hfl
    have : beta * g l < 0 := mul_neg_of_pos_of_neg hbp hl
    linarith
  · push_neg at hbp
    have hbn : beta < 0 := lt_of_le_of_ne hbp hbeta
    obtain ⟨l, hl⟩ := hg_pos
    have hfl := hf l
    rw [hFOC l] at hfl
    have : beta * g l < 0 := mul_neg_of_neg_of_pos hbn hl
    linarith