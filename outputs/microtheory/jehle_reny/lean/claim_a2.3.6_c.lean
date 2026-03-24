import Mathlib
open Topology

theorem Claim_A2_3_6_c
    (f1 f2 g1_1 g1_2 g2_1 g2_2 : ℝ)
    (hf1 : 0 < f1) (hf2 : 0 < f2)
    (hg1_1 : 0 < g1_1) (hg1_2 : 0 < g1_2)
    (hg2_1 : 0 < g2_1) (hg2_2 : 0 < g2_2) :
    (-(g1_1 / g1_2) ≤ -(f1 / f2) ∧ -(f1 / f2) ≤ -(g2_1 / g2_2)) ↔
    (g1_2 / g1_1 ≤ f2 / f1 ∧ f2 / f1 ≤ g2_2 / g2_1) := by
  have cross : ∀ {a b c d : ℝ}, 0 < b → 0 < d →
      (a / b ≤ c / d ↔ a * d ≤ c * b) := by
    intro a b c d hb hd
    have hbn : b ≠ 0 := hb.ne'
    have hdn : d ≠ 0 := hd.ne'
    constructor
    · intro h
      have hbd : (0 : ℝ) ≤ b * d := (mul_pos hb hd).le
      have h' := mul_le_mul_of_nonneg_right h hbd
      have eq1 : a / b * (b * d) = a * d := by field_simp
      have eq2 : c / d * (b * d) = c * b := by field_simp
      linarith
    · intro h
      have hbdi : (0 : ℝ) ≤ (b * d)⁻¹ := by positivity
      have h' := mul_le_mul_of_nonneg_right h hbdi
      have eq1 : a * d * (b * d)⁻¹ = a / b := by field_simp
      have eq2 : c * b * (b * d)⁻¹ = c / d := by field_simp
      linarith
  simp only [neg_le_neg_iff, cross hf2 hg1_2, cross hg2_2 hf2,
             cross hg1_1 hf1, cross hf1 hg2_1]
  constructor <;> intro ⟨h1, h2⟩ <;> exact ⟨by nlinarith, by nlinarith⟩