import Mathlib

open Set

noncomputable def cross (u v : ℝ × ℝ) : ℝ := u.1 * v.2 - u.2 * v.1

lemma cross_sub_left (u v w : ℝ × ℝ) : cross (u - v) w = cross u w - cross v w := by
  unfold cross
  simp [sub_mul, mul_sub]
  ring