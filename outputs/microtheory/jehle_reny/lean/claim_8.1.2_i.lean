import Mathlib

/-- Claim 8.1.2(i): When MRS_l(0,0) < π̄, the low-risk consumer optimally
    chooses no insurance on the pooled zero-profit line p = π̄·B.
    g(B) = u_l(B, π̄·B) is concave with g'(0) ≤ 0, so g(0) is maximal. -/
theorem Claim_8_1_2_i
    {g : ℝ → ℝ} {g'₀ : ℝ}
    -- Concavity of utility along pooled zero-profit line
    (hconc : ConcaveOn ℝ (Set.Ici (0 : ℝ)) g)
    -- Supergradient inequality at B = 0 (consequence of concavity + differentiability)
    (hsub : ∀ B : ℝ, 0 ≤ B → g B ≤ g 0 + g'₀ * B)
    -- MRS_l(0,0) < π̄ ⟹ g'(0) ≤ 0 (indifference curve flatter than budget line)
    (hmrs : g'₀ ≤ 0)
    : ∀ B : ℝ, 0 ≤ B → g 0 ≥ g B := by
  intro B hB
  have h1 := hsub B hB
  have h2 : g'₀ * B ≤ 0 := mul_nonpos_of_nonpos_of_nonneg hmrs hB
  linarith