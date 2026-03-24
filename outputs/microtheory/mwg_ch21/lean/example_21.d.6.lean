import Mathlib
open Topology

noncomputable def euclideanUtility (n : ℕ) (peak : EuclideanSpace ℝ (Fin n)) (y : EuclideanSpace ℝ (Fin n)) : ℝ :=
  -‖y - peak‖

def euclideanPreferredSet (n : ℕ) (y z : EuclideanSpace ℝ (Fin n)) : Set (EuclideanSpace ℝ (Fin n)) :=
  {x | ‖x - y‖ < ‖x - z‖}