import Mathlib

theorem real_abs_sub_is_metric :
    (∀ x : ℝ, |x - x| = 0) ∧
    (∀ x y z : ℝ, |x - y| + |y - z| ≥ |x - z|) ∧
    (∀ x y : ℝ, |x - y| = |y - x|) ∧
    (∀ x y : ℝ, x ≠ y → 0 < |x - y|) := by
  refine ⟨by simp, fun x y z => (abs_sub_le x y z).ge, fun x y => abs_sub_comm x y, fun x y h => abs_pos.mpr (sub_ne_zero.mpr h)⟩