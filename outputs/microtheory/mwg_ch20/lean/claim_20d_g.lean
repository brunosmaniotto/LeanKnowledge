import Mathlib

theorem Claim_20D_g
    (α δ : ℝ)
    (hα_pos : 0 < α)
    (hδ_pos : 0 < δ)
    (hδ_lt : δ < 1)
    (hα_gt : 1 < α)
    (hαδ : α * δ < 1) :
    (∀ t : ℕ, 0 < (1 / α ^ t : ℝ)) ∧
    (∀ t : ℕ, 0 < (α * δ) ^ t * (1 - δ)) ∧
    (∀ t : ℕ, (1 / α ^ t : ℝ) ≤ 1) ∧
    (∀ t : ℕ, (α * δ) ^ t * (1 - δ) ≤ 1 - δ) := by
  have hαt_pos : ∀ t : ℕ, (0 : ℝ) < α ^ t := fun t => pow_pos hα_pos t
  have hαδ_pos : 0 < α * δ := mul_pos hα_pos hδ_pos
  have hαδ_nonneg : 0 ≤ α * δ := le_of_lt hαδ_pos
  have h1δ : 0 < 1 - δ := by linarith
  have hα_le : 1 ≤ α := le_of_lt hα_gt
  refine ⟨fun t => by positivity, fun t => by positivity, fun t => ?_, fun t => ?_⟩
  · rw [one_div]
    apply inv_le_one_of_one_le₀
    exact one_le_pow₀ hα_le
  · have h1 : (α * δ) ^ t ≤ 1 := pow_le_one₀ hαδ_nonneg (le_of_lt hαδ)
    nlinarith [h1δ]