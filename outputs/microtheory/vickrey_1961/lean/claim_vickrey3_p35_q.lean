import Mathlib

theorem claim_vickrey3_p35_q (a x k : ℝ) (hk : k = a ^ 2 / 4)
    (hx : x ≠ 0) (hax : a - x ≠ 0) :
    a - k / x = a - a ^ 2 / (4 * x) ∧
    k / (a - x) = a ^ 2 / (4 * (a - x)) := by
  subst hk
  constructor <;> field_simp