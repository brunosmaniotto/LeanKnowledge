import Mathlib
open Topology

/-- Classification of indifference curves: each is either horizontal or vertical -/
inductive CurveType where
  | horizontal
  | vertical

/-- Under Arrow's conditions with strict welfarism for N=2,
    indifference curves cannot cross, so they must all be the same type.
    Horizontal ↔ individual 2 is dictator, Vertical ↔ individual 1 is dictator. -/
theorem claim_6B_d
    (curveAt : ℝ × ℝ → CurveType)
    (no_crossing : ∀ p q : ℝ × ℝ, curveAt p = curveAt q)
    : (∀ p, curveAt p = CurveType.horizontal) ∨ (∀ p, curveAt p = CurveType.vertical) := by
  rcases h : curveAt (0, 0) with _ | _
  · left
    intro p
    rw [no_crossing p (0, 0), h]
  · right
    intro p
    rw [no_crossing p (0, 0), h]