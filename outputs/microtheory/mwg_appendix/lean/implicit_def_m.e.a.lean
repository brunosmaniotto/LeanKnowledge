import Mathlib

/-- A set `A'` is an open neighborhood of `x` in `ℝ^N` if `A' = {x' : ‖x' - x‖ < ε}` for some `ε > 0`. -/
def MWG.IsOpenNeighborhood {N : ℕ} (A' : Set (EuclideanSpace ℝ (Fin N))) (x : EuclideanSpace ℝ (Fin N)) : Prop :=
  ∃ ε > 0, A' = Metric.ball x ε