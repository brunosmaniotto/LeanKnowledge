import Mathlib

theorem Example_13B1 (α w : ℝ) (hα : α > 1 / 2) (hw : w > 0) :
    w / (2 * α) < w := by
  have hα_pos : 2 * α > 0 := by linarith
  have hα_ne : 2 * α ≠ 0 := ne_of_gt hα_pos
  rw [div_lt_iff₀ hα_pos]
  nlinarith