import Mathlib
open Topology

/-- Property (i) of production sets: Y is nonempty.
    The firm has something it can plan to do. -/
def Property_5B_i {n : ℕ} (Y : Set (Fin n → ℝ)) : Prop :=
  Y.Nonempty