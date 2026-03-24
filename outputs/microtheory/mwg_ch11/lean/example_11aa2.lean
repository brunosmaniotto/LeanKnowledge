import Mathlib

open Set

theorem Example_11AA2
    (f : ℝ → ℝ) (f' : ℝ → ℝ)
    (hf_concave : ConcaveOn ℝ (Ioi 0) f)
    (hf_diff : ∀ x ∈ Ioi 0, HasDerivAt f (f' x) x)
    (hf_strict_dec : ∃ a ∈ Ioi 0, f' a < 0)
    (hf_nonneg : ∀ x ∈ Ioi 0, 0 ≤ f x) : False := by
  obtain ⟨a, ha_pos, ha_neg⟩ := hf_strict_dec
  have hfa_nn : 0 ≤ f a := hf_nonneg a ha_pos
  have hf'a_neg : -f' a > 0 := by linarith
  have hf'a_ne : f' a ≠ 0 := ne_of_lt ha_neg
  set b := a + (f a / (-f' a)) + 1 with hb_def
  have hb_gt_a : a < b := by
    simp only [hb_def]; linarith [div_nonneg hfa_nn (le_of_lt hf'a_neg)]
  have hb_pos : b ∈ Ioi (0 : ℝ) := by
    simp only [mem_Ioi] at ha_pos ⊢; linarith
  have hba_pos : (0 : ℝ) < b - a := by linarith
  have h_slope : slope f a b ≤ f' a :=
    hf_concave.slope_le_of_hasDerivWithinAt ha_pos hb_pos hb_gt_a
      (hf_diff a ha_pos).hasDerivWithinAt
  have h_tangent_bound : f b ≤ f a + f' a * (b - a) := by
    have hslope_eq : slope f a b = (b - a)⁻¹ * (f b - f a) := by
      simp [slope, vsub_eq_sub]
    rw [hslope_eq] at h_slope
    rw [inv_mul_le_iff₀ hba_pos] at h_slope
    linarith
  have h_tangent_neg : f a + f' a * (b - a) < 0 := by
    have hba : b - a = f a / (-f' a) + 1 := by rw [hb_def]; ring
    rw [hba, mul_add, mul_one]
    have key : f' a * (f a / (-f' a)) = -f a := by field_simp
    linarith
  linarith [hf_nonneg b hb_pos]