import Mathlib

theorem Claim_A2_3_6_b
    (f₁ f₂ g₁₁ g₁₂ g₂₁ g₂₂ μ₁ μ₂ : ℝ)
    (hf₁ : 0 < f₁) (hf₂ : 0 < f₂)
    (hg₁₁ : 0 < g₁₁) (hg₁₂ : 0 < g₁₂)
    (hg₂₁ : 0 < g₂₁) (hg₂₂ : 0 < g₂₂)
    (hμ₁ : 0 ≤ μ₁) (hμ₂ : 0 ≤ μ₂)
    (hkkt1 : f₁ = μ₁ * g₁₁ + μ₂ * g₂₁)
    (hkkt2 : f₂ = μ₁ * g₁₂ + μ₂ * g₂₂)
    (hslope : g₁₂ * g₂₁ ≤ g₁₁ * g₂₂) :
    -(g₁₁ / g₁₂) ≤ -(f₁ / f₂) ∧ -(f₁ / f₂) ≤ -(g₂₁ / g₂₂) := by
  have hsd : 0 ≤ g₁₁ * g₂₂ - g₁₂ * g₂₁ := by linarith
  have h1 : 0 ≤ g₁₁ * f₂ - f₁ * g₁₂ := by
    have : g₁₁ * f₂ - f₁ * g₁₂ = μ₂ * (g₁₁ * g₂₂ - g₁₂ * g₂₁) := by
      rw [hkkt1, hkkt2]; ring
    linarith [mul_nonneg hμ₂ hsd]
  have h2 : 0 ≤ f₁ * g₂₂ - g₂₁ * f₂ := by
    have : f₁ * g₂₂ - g₂₁ * f₂ = μ₁ * (g₁₁ * g₂₂ - g₁₂ * g₂₁) := by
      rw [hkkt1, hkkt2]; ring
    linarith [mul_nonneg hμ₁ hsd]
  refine ⟨?_, ?_⟩
  · rw [neg_le_neg_iff, ← sub_nonneg, div_sub_div _ _ hg₁₂.ne' hf₂.ne']
    exact div_nonneg (by linarith) (by positivity)
  · rw [neg_le_neg_iff, ← sub_nonneg, div_sub_div _ _ hf₂.ne' hg₂₂.ne']
    exact div_nonneg (by linarith) (by positivity)