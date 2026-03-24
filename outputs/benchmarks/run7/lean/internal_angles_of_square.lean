import Mathlib

namespace InternalAngleSquare

axiom IsSquare (S : Type) : Prop
axiom IsRegularQuadrilateral (S : Type) : Prop
axiom IsRegularPolygon (S : Type) (n : ℕ) : Prop
axiom IsInternalAngle (S : Type) (α : Type) : Prop
axiom angle_measure (α : Type) : ℝ
axiom IsRightAngle (α : Type) : Prop

axiom square_is_regular_quadrilateral (S : Type) : IsSquare S → IsRegularQuadrilateral S
axiom regular_quadrilateral_is_regular_polygon (S : Type) : IsRegularQuadrilateral S → IsRegularPolygon S 4
axiom internal_angle_of_regular_polygon (S : Type) (n : ℕ) (h : IsRegularPolygon S n) (α : Type) (hα : IsInternalAngle S α) :
    angle_measure α = (180 : ℝ) * ((n : ℝ) - (2 : ℝ)) / (n : ℝ)
axiom is_right_angle_iff_measure_eq_90 (α : Type) : IsRightAngle α ↔ angle_measure α = (90 : ℝ)

theorem internal_angles_of_square (S : Type) (α : Type) (hS : IsSquare S) (hα : IsInternalAngle S α) :
    IsRightAngle α := by
  have h1 : IsRegularQuadrilateral S := square_is_regular_quadrilateral S hS
  have h2 : IsRegularPolygon S 4 := regular_quadrilateral_is_regular_polygon S h1
  have h3 : angle_measure α = (180 : ℝ) * ((4 : ℝ) - (2 : ℝ)) / (4 : ℝ) :=
    internal_angle_of_regular_polygon S 4 h2 α hα
  have h4 : angle_measure α = (90 : ℝ) := by
    rw [h3]
    norm_num
  exact (is_right_angle_iff_measure_eq_90 α).mpr h4

end InternalAngleSquare