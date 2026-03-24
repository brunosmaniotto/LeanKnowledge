import Mathlib

/-- In the proof of Theorem 6.2, for any point ũ in region I (to the left of ū,
    below the 45° line, and above the ray from a on the 45° line through ū),
    the inequalities ū₂ < ũ₂ < ũ₁ < ū₁ hold, so Hammond Equity implies W(ũ) ≥ W(ū). -/
theorem Claim_6D_a
    {W : ℝ × ℝ → ℝ}
    {ū ũ : ℝ × ℝ}
    -- Region I constraints: ũ is left of ū, below 45° line, above the ray
    (h_left : ũ.1 < ū.1)
    (h_below_diag : ũ.2 < ũ.1)
    (h_above_ray : ū.2 < ũ.2)
    -- Hammond Equity: if ū₂ < ũ₂ < ũ₁ < ū₁ then W(ũ) ≥ W(ū)
    (HE : ū.2 < ũ.2 → ũ.2 < ũ.1 → ũ.1 < ū.1 → W ũ ≥ W ū) :
    ū.2 < ũ.2 ∧ ũ.2 < ũ.1 ∧ ũ.1 < ū.1 ∧ W ũ ≥ W ū := by
  exact ⟨h_above_ray, h_below_diag, h_left, HE h_above_ray h_below_diag h_left⟩