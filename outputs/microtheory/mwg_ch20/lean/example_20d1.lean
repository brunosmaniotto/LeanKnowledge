import Mathlib

open Finset BigOperators

theorem Example_20D1
    (δ w : ℝ) (hδ_pos : 0 < δ) (hδ_lt : δ < 1) (hw : 0 < w)
    (pc : ℕ → ℝ)
    (hpc : ∀ t, pc t = δ ^ t * (1 - δ) * w)
    (tail_sum : ℕ → ℝ)
    (htail : ∀ t, tail_sum t = δ ^ t * w)
    : ∀ t, pc t / tail_sum t = 1 - δ := by
  intro t
  rw [hpc t, htail t]
  have hδt_pos : (0 : ℝ) < δ ^ t := pow_pos hδ_pos t
  have hdenom_pos : (0 : ℝ) < δ ^ t * w := mul_pos hδt_pos hw
  field_simp