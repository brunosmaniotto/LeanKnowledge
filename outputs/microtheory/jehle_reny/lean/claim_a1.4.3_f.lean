import Mathlib

theorem claim_A1_4_3_f :
    ∃ f : ℝ → ℝ,
      (∀ x y : ℝ, ∀ t : ℝ, 0 ≤ t → t ≤ 1 →
        f (t * x + (1 - t) * y) ≥ min (f x) (f y)) ∧
      ¬(∀ x y : ℝ, ∀ t : ℝ, 0 ≤ t → t ≤ 1 →
        f (t * x + (1 - t) * y) ≥ t * f x + (1 - t) * f y) := by
  use fun x => x ^ 3
  refine ⟨fun x y t ht0 ht1 => ?_, ?_⟩
  · -- Quasiconcavity: x³ is monotone increasing, convex combo lies between x and y
    simp only [ge_iff_le]
    suffices cube_mono : ∀ a b : ℝ, a ≤ b → a ^ 3 ≤ b ^ 3 by
      rcases le_total x y with hxy | hxy
      · exact le_trans (min_le_left _ _) (cube_mono x _ (by nlinarith))
      · exact le_trans (min_le_right _ _) (cube_mono y _ (by nlinarith))
    intro a b hab
    have h1 : 0 ≤ b - a := sub_nonneg.mpr hab
    have h2 : 0 ≤ b ^ 2 + b * a + a ^ 2 := by
      nlinarith [sq_nonneg (b + a / 2), sq_nonneg a]
    calc a ^ 3
        ≤ a ^ 3 + (b - a) * (b ^ 2 + b * a + a ^ 2) := by linarith [mul_nonneg h1 h2]
      _ = b ^ 3 := by ring
  · -- Not concave: f(1/2) = 1/8 < 1/2 · 0³ + 1/2 · 1³ = 1/2
    push_neg
    exact ⟨0, 1, 1 / 2, by norm_num, by norm_num, by norm_num⟩