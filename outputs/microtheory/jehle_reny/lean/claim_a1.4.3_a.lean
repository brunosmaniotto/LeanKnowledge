import Mathlib
open Topology

theorem claim_A1_4_3_a :
    (∀ f : ℝ → ℝ, (∀ x y t : ℝ, 0 ≤ t → t ≤ 1 →
        f (t * x + (1 - t) * y) ≥ t * f x + (1 - t) * f y) →
      (∀ x y t : ℝ, 0 ≤ t → t ≤ 1 →
        f (t * x + (1 - t) * y) ≥ min (f x) (f y))) ∧
    (∃ f : ℝ → ℝ,
      (∀ x y t : ℝ, 0 ≤ t → t ≤ 1 →
        f (t * x + (1 - t) * y) ≥ min (f x) (f y)) ∧
      ¬(∀ x y t : ℝ, 0 ≤ t → t ≤ 1 →
        f (t * x + (1 - t) * y) ≥ t * f x + (1 - t) * f y)) := by
  constructor
  · -- Concavity implies quasiconcavity
    intro f hconc x y t ht0 ht1
    have hc := hconc x y t ht0 ht1
    have : min (f x) (f y) ≤ t * f x + (1 - t) * f y := by
      rcases le_total (f x) (f y) with h | h
      · rw [min_eq_left h]; nlinarith
      · rw [min_eq_right h]; nlinarith
    linarith
  · -- Counterexample: x³ is monotone (hence quasiconcave) but not concave
    use fun x => x ^ 3
    refine ⟨?_, ?_⟩
    · intro x y t ht0 ht1
      show (t * x + (1 - t) * y) ^ 3 ≥ min (x ^ 3) (y ^ 3)
      rw [ge_iff_le]
      have cube_mono : ∀ a b : ℝ, a ≤ b → a ^ 3 ≤ b ^ 3 := by
        intro a b hab
        have h1 : b ^ 2 + a * b + a ^ 2 ≥ 0 := by
          nlinarith [sq_nonneg a, sq_nonneg b, sq_nonneg (a + b)]
        have h2 : b ^ 3 - a ^ 3 = (b - a) * (b ^ 2 + a * b + a ^ 2) := by ring
        linarith [mul_nonneg (sub_nonneg.mpr hab) h1]
      rcases le_total x y with hxy | hxy
      · exact le_trans (min_le_left _ _) (cube_mono _ _ (by nlinarith))
      · exact le_trans (min_le_right _ _) (cube_mono _ _ (by nlinarith))
    · -- Not concave: (1/2)³ = 1/8 < 1/2 = 1/2·0³ + 1/2·1³
      push_neg
      exact ⟨0, 1, 1/2, by norm_num, by norm_num, by norm_num⟩