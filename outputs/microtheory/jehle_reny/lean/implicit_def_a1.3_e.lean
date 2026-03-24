import Mathlib

open Metric Set Topology
open Topology

/-- A point x is a boundary point of S if every ε-ball around x contains
    points in S and points not in S. In Mathlib this is `frontier`. -/
abbrev MWG.IsFixedPoint {n : ℕ} (x : EuclideanSpace ℝ (Fin n)) (S : Set (EuclideanSpace ℝ (Fin n))) : Prop :=
  x ∈ frontier S

/-- The set of all boundary points of S (denoted ∂S). -/
abbrev MWG.boundary {n : ℕ} (S : Set (EuclideanSpace ℝ (Fin n))) : Set (EuclideanSpace ℝ (Fin n)) :=
  frontier S