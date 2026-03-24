import Mathlib

open TopologicalSpace Set
open Topology

theorem Claim_1_2_1_g {n : ℕ}
    (upper lower : Set (EuclideanSpace ℝ (Fin n)))
    (h_upper : IsClosed upper) (h_lower : IsClosed lower) :
    IsClosed (upper ∩ lower) :=
  h_upper.inter h_lower