import Mathlib

open Set
set_option linter.unusedVariables false

theorem Claim_9_8_subsidies : IsGreatest ((fun t : ℝ => 0 - (1/2 : ℝ) * t ^ 2) '' Set.Icc (0:ℝ) 1) 0 ∧
    IsGreatest ((fun t : ℝ => t - (1/2 : ℝ) * t ^ 2) '' Set.Icc (0:ℝ) 1) (1/2) ∧
    (0 : ℝ) + 1/2 = 1/2 ∧ (1/2 : ℝ) > 1/3 := by
  have h0_in : (0 : ℝ) ∈ Set.Icc (0 : ℝ) 1 := by constructor <;> norm_num
  have h1_in : (1 : ℝ) ∈ Set.Icc (0 : ℝ) 1 := by constructor <;> norm_num
  have hf_b0 : (fun t : ℝ => 0 - (1/2 : ℝ) * t ^ 2) 0 = 0 := by norm_num
  have hf_s1 : (fun t : ℝ => t - (1/2 : ℝ) * t ^ 2) 1 = 1/2 := by norm_num
  have hb_bound : ∀ t, t ∈ Set.Icc (0 : ℝ) 1 → (fun t : ℝ => 0 - (1/2 : ℝ) * t ^ 2) t ≤ 0 := by
    intro t ⟨htl, htr⟩
    dsimp
    nlinarith [sq_nonneg t]
  have hs_bound : ∀ t, t ∈ Set.Icc (0 : ℝ) 1 → (fun t : ℝ => t - (1/2 : ℝ) * t ^ 2) t ≤ 1/2 := by
    intro t ⟨htl, htr⟩
    dsimp
    nlinarith [sq_nonneg (t - 1)]
  have hb_greatest : IsGreatest ((fun t : ℝ => 0 - (1/2 : ℝ) * t ^ 2) '' Set.Icc (0:ℝ) 1) 0 := by
    constructor
    · exact ⟨0, h0_in, hf_b0⟩
    · rintro _ ⟨t, ht, rfl⟩
      exact hb_bound t ht
  have hs_greatest : IsGreatest ((fun t : ℝ => t - (1/2 : ℝ) * t ^ 2) '' Set.Icc (0:ℝ) 1) (1/2) := by
    constructor
    · exact ⟨1, h1_in, hf_s1⟩
    · rintro _ ⟨t, ht, rfl⟩
      exact hs_bound t ht
  exact ⟨hb_greatest, hs_greatest, by norm_num, by norm_num⟩