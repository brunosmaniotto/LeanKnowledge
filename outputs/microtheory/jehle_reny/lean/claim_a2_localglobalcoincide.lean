import Mathlib

open Set

theorem local_global_coincide_concave_convex :
    (∀ (f : ℝ → ℝ), ConcaveOn ℝ univ f →
      ∀ x, (∃ ε > 0, ∀ y, |y - x| < ε → f y ≤ f x) → ∀ y, f y ≤ f x) ∧
    (∀ (f : ℝ → ℝ), ConvexOn ℝ univ f →
      ∀ x, (∃ ε > 0, ∀ y, |y - x| < ε → f x ≤ f y) → ∀ y, f x ≤ f y) := by
  constructor
  · -- Concave case: local max ⟹ global max
    intro f hf x ⟨ε, hε, hloc⟩ y
    by_contra hc; push_neg at hc
    have hne : y ≠ x := by rintro rfl; linarith
    have hyx : (0 : ℝ) < |y - x| := abs_pos.mpr (sub_ne_zero.mpr hne)
    have h2yx : (0 : ℝ) < 2 * |y - x| := by positivity
    let t := min (ε / (2 * |y - x|)) (1 / 2)
    have ht : 0 < t := lt_min (div_pos hε h2yx) (by norm_num)
    have htl : t ≤ 1 / 2 := min_le_right _ _
    have hball : |(1 - t) * x + t * y - x| < ε := by
      have heq : (1 - t) * x + t * y - x = t * (y - x) := by ring
      rw [heq, abs_mul, abs_of_pos ht]
      have h1 : t ≤ ε / (2 * |y - x|) := min_le_left _ _
      have h2 := mul_le_mul_of_nonneg_right h1 (le_of_lt hyx)
      have h3 : ε / (2 * |y - x|) * |y - x| = ε / 2 := by field_simp
      linarith
    have hcv := hf.2 (mem_univ x) (mem_univ y)
      (show (0 : ℝ) ≤ 1 - t by linarith) (le_of_lt ht) (show (1 - t) + t = 1 by ring)
    simp only [smul_eq_mul] at hcv
    nlinarith [hloc _ hball, mul_pos ht (sub_pos.mpr hc)]
  · -- Convex case: local min ⟹ global min
    intro f hf x ⟨ε, hε, hloc⟩ y
    by_contra hc; push_neg at hc
    have hne : y ≠ x := by rintro rfl; linarith
    have hyx : (0 : ℝ) < |y - x| := abs_pos.mpr (sub_ne_zero.mpr hne)
    have h2yx : (0 : ℝ) < 2 * |y - x| := by positivity
    let t := min (ε / (2 * |y - x|)) (1 / 2)
    have ht : 0 < t := lt_min (div_pos hε h2yx) (by norm_num)
    have htl : t ≤ 1 / 2 := min_le_right _ _
    have hball : |(1 - t) * x + t * y - x| < ε := by
      have heq : (1 - t) * x + t * y - x = t * (y - x) := by ring
      rw [heq, abs_mul, abs_of_pos ht]
      have h1 : t ≤ ε / (2 * |y - x|) := min_le_left _ _
      have h2 := mul_le_mul_of_nonneg_right h1 (le_of_lt hyx)
      have h3 : ε / (2 * |y - x|) * |y - x| = ε / 2 := by field_simp
      linarith
    have hcv := hf.2 (mem_univ x) (mem_univ y)
      (show (0 : ℝ) ≤ 1 - t by linarith) (le_of_lt ht) (show (1 - t) + t = 1 by ring)
    simp only [smul_eq_mul] at hcv
    nlinarith [hloc _ hball, mul_pos ht (sub_pos.mpr hc)]