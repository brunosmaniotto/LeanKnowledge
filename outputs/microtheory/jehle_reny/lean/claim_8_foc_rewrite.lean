import Mathlib

/-- The first-order condition (8.19) for the asymmetric information problem
    with e = 1 can be rewritten in terms of the inverse of marginal utility. -/
theorem Claim_8_FOC_rewrite
    (π₀ π₁ lam β du : ℝ)
    (hπ₁ : 0 < π₁)
    (hdu : 0 < du)
    (hFOC : -π₁ + (lam * π₁ + β * (π₁ - π₀)) * du = 0) :
    1 / du = lam + β * (1 - π₀ / π₁) := by
  have hdu_ne : du ≠ 0 := ne_of_gt hdu
  have hπ₁_ne : π₁ ≠ 0 := ne_of_gt hπ₁
  field_simp
  nlinarith