import Mathlib

theorem Example_21_D_5 :
    ∀ x₁ x₂ : ℝ, 0 ≤ x₁ → x₁ ≤ 1 → 0 ≤ x₂ → x₂ ≤ 1 →
    ∃ y₁ y₂ : ℝ, 0 ≤ y₁ ∧ y₁ ≤ 1 ∧ 0 ≤ y₂ ∧ y₂ ≤ 1 ∧
      ((-2 * y₁ - y₂ > -2 * x₁ - x₂ ∧ y₁ + 2 * y₂ > x₁ + 2 * x₂) ∨
       (-2 * y₁ - y₂ > -2 * x₁ - x₂ ∧ y₁ - y₂ > x₁ - x₂) ∨
       (y₁ + 2 * y₂ > x₁ + 2 * x₂ ∧ y₁ - y₂ > x₁ - x₂)) := by
  intro x₁ x₂ hx₁0 hx₁1 hx₂0 hx₂1
  by_cases hx₂_zero : x₂ = 0
  · -- Case (i): x₂ = 0, pick y with larger x₁ — agents 2 and 3 prefer it
    by_cases hx₁1' : x₁ = 1
    · -- x = (1, 0): pick y = (0, 1)
      exact ⟨0, 1, by norm_num, by norm_num, by norm_num, by norm_num,
        Or.inl ⟨by subst hx₂_zero; subst hx₁1'; norm_num, by subst hx₂_zero; subst hx₁1'; norm_num⟩⟩
    · -- x₁ < 1: pick y = ((x₁+1)/2, 0)
      have hx₁_lt : x₁ < 1 := lt_of_le_of_ne hx₁1 hx₁1'
      exact ⟨(x₁ + 1) / 2, 0, by linarith, by linarith, by linarith, by linarith,
        Or.inr (Or.inr ⟨by subst hx₂_zero; nlinarith, by subst hx₂_zero; nlinarith⟩)⟩
  · by_cases hx₂_one : x₂ = 1
    · -- Case (ii): x₂ = 1, pick y = (x₁, 1/2) — agents 1 and 3 prefer less x₂
      exact ⟨x₁, 1 / 2, hx₁0, hx₁1, by linarith, by linarith,
        Or.inr (Or.inl ⟨by subst hx₂_one; nlinarith, by subst hx₂_one; nlinarith⟩)⟩
    · -- Case (iii): 0 < x₂ < 1
      have hx₂_pos : x₂ > 0 := lt_of_le_of_ne hx₂0 (Ne.symm hx₂_zero)
      have hx₂_lt1 : x₂ < 1 := lt_of_le_of_ne hx₂1 hx₂_one
      by_cases hx₁0' : x₁ = 0
      · -- x₁ = 0: pick y = ((1-x₂)/2, x₂), agents 2 and 3 prefer it
        exact ⟨(1 - x₂) / 2, x₂, by linarith, by linarith, hx₂0, hx₂1,
          Or.inr (Or.inr ⟨by subst hx₁0'; nlinarith, by subst hx₁0'; nlinarith⟩)⟩
      · -- x₁ > 0: pick ε = min(x₁, 1-x₂)/2, y = (x₁ - ε, x₂ + ε)
        have hx₁_pos : x₁ > 0 := lt_of_le_of_ne hx₁0 (Ne.symm hx₁0')
        have hmin_pos : min x₁ (1 - x₂) > 0 := by
          simp [lt_min_iff]; exact ⟨hx₁_pos, by linarith⟩
        have hε_pos : min x₁ (1 - x₂) / 2 > 0 := by linarith
        have hε_le_x₁ : min x₁ (1 - x₂) / 2 ≤ x₁ := by
          have := min_le_left x₁ (1 - x₂); linarith
        have hε_le_comp : min x₁ (1 - x₂) / 2 ≤ (1 - x₂) := by
          have := min_le_right x₁ (1 - x₂); linarith
        exact ⟨x₁ - min x₁ (1 - x₂) / 2, x₂ + min x₁ (1 - x₂) / 2,
          by linarith, by linarith, by linarith, by linarith,
          Or.inl ⟨by nlinarith, by nlinarith⟩⟩