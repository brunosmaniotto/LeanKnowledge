import Mathlib
import Mathlib.Analysis.InnerProductSpace.Basic

open RealInnerProductSpace

/-- In an inner product space, for any three points A, B, C where (A - B) and (B - C) are not
on the same ray (i.e., the triangle is non-degenerate at vertex B), the sum of lengths of
two sides exceeds the third: ‖A - C‖ < ‖A - B‖ + ‖B - C‖. -/
theorem sum_of_two_sides_gt_third_side {V : Type*} [NormedAddCommGroup V] [InnerProductSpace ℝ V]
    (A B C : V) (h : ¬ SameRay ℝ (A - B) (B - C)) : ‖A - C‖ < ‖A - B‖ + ‖B - C‖ := by
  have H : A - C = (A - B) + (B - C) := by abel
  rw [H]
  exact norm_add_lt_of_not_sameRay h