import Mathlib
open Topology

theorem Theorem_A1_1 {n : ℕ} {S T : Set (EuclideanSpace ℝ (Fin n))}
    (hS : Convex ℝ S) (hT : Convex ℝ T) : Convex ℝ (S ∩ T) :=
  hS.inter hT