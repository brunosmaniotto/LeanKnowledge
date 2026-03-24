import Mathlib

/-- A point `x` is a fixed point of a function `f` if `x = f x`. -/
def MWG.IsFixedPoint {N : ℕ} (f : EuclideanSpace ℝ (Fin N) → EuclideanSpace ℝ (Fin N)) (x : EuclideanSpace ℝ (Fin N)) : Prop :=
  x = f x