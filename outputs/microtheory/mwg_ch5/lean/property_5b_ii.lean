import Mathlib
open Topology

/-- Property (5.B.ii): A production set Y is closed.
    Equivalently, the limit of any convergent sequence of
    technologically feasible input–output vectors is also feasible. -/
def ProductionSet.IsClosed_5Bii {n : ℕ} (Y : Set (EuclideanSpace ℝ (Fin n))) : Prop :=
  IsClosed Y