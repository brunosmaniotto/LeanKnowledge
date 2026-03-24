import Mathlib

open Metric

namespace MWG

/-- An open ball around x ∈ ℝ^N with radius ε > 0. -/
abbrev openBall (N : ℕ) (x : EuclideanSpace ℝ (Fin N)) (ε : ℝ) : Set (EuclideanSpace ℝ (Fin N)) :=
  Metric.ball x ε

end MWG