import Mathlib

theorem claim_vickrey3_p35_m
    (a k : ℝ) (hk : k > a ^ 2 / 4) :
    ∀ x : ℝ, 0 < a - x → k / (a - x) > x := by
  intro x hax
  rw [gt_iff_lt, ← sub_pos]
  have hne : (a - x) ≠ 0 := by linarith
  have heq : k / (a - x) - x = (k - x * (a - x)) / (a - x) := by
    field_simp
  rw [heq]
  apply div_pos
  · nlinarith [sq_nonneg (a - 2 * x)]
  · exact hax