import Mathlib

open Set

lemma neg_mul_pos_of_neg_of_pos {a b : ℝ} (ha : a < 0) (hb : b > 0) : -a * b > 0 := by
  have h_neg_a_pos : -a > 0 := by linarith [ha]
  exact mul_pos h_neg_a_pos hb