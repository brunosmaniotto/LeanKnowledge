import Mathlib

/-- If consumer 2 has a globally higher certainty equivalent than consumer 1
    for every gamble (which follows from R¹_A(w) > R²_A(w) for all w),
    then consumer 2 accepts any gamble that consumer 1 accepts. -/
theorem Claim_2_4_3_h
    {Gamble : Type*}
    (CE₁ CE₂ : Gamble → ℝ)
    (w₀ : ℝ)
    (hCE : ∀ g : Gamble, CE₁ g < CE₂ g) :
    ∀ g, w₀ ≤ CE₁ g → w₀ ≤ CE₂ g := by
  intro g h1
  linarith [hCE g]