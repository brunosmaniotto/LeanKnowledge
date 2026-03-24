import Mathlib
open Topology

theorem claim_A1_3_1_b (n : ℕ) (x : EuclideanSpace ℝ (Fin n)) :
    IsClosed ({x} : Set (EuclideanSpace ℝ (Fin n))) :=
  isClosed_singleton