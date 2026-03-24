import Mathlib

theorem Claim_3_2_1_b :
    (∀ (α : ℝ) (f : ℝ → ℝ),
      (∀ t : ℝ, t > 0 → ∀ x : ℝ, f (t * x) = t ^ α * f x) →
      α > 1 →
      ∀ t : ℝ, t > 1 → ∀ x : ℝ, f x > 0 → f (t * x) > t * f x) ∧
    (∃ f : ℝ → ℝ,
      (∀ t : ℝ, t > 1 → ∀ x : ℝ, x > 0 → f (t * x) > t * f x) ∧
      ∀ α : ℝ, ¬(∀ t : ℝ, t > 0 → ∀ x : ℝ, f (t * x) = t ^ α * f x)) := by
  constructor
  · -- Homogeneous degree α > 1 implies f(tx) > tf(x) for t > 1
    intro α f hf hα t ht x hfx
    rw [hf t (by linarith) x]
    have h1 : t < t ^ α := by
      have := Real.rpow_lt_rpow_of_exponent_lt (show (1 : ℝ) < t by linarith)
        (show (1 : ℝ) < α by linarith)
      simpa using this
    exact mul_lt_mul_of_pos_right h1 hfx
  · -- f(x) = x² + x has IRS but is not homogeneous of any degree
    refine ⟨fun x => x ^ 2 + x, ?_, ?_⟩
    · intro t ht x hx
      have ht0 : (0 : ℝ) < t := by linarith
      have htm : (0 : ℝ) < t - 1 := by linarith
      have hx2 : (0 : ℝ) < x ^ 2 := by positivity
      nlinarith [mul_pos (mul_pos hx2 ht0) htm]
    · intro α hα
      have h1 := hα 2 (by norm_num : (2 : ℝ) > 0) 1
      have h2 := hα 2 (by norm_num : (2 : ℝ) > 0) 2
      norm_num at h1 h2
      have : (2 : ℝ) ^ α * 6 = 3 * ((2 : ℝ) ^ α * 2) := by ring
      linarith