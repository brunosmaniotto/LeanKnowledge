import Mathlib

open Set Convex
open Topology

variable {n : ℕ} {D : Set (EuclideanSpace ℝ (Fin n))} {f : EuclideanSpace ℝ (Fin n) → ℝ}

/-- The hypograph (set of points on and below the graph) of f over D. -/
def hypograph (D : Set (EuclideanSpace ℝ (Fin n))) (f : EuclideanSpace ℝ (Fin n) → ℝ) : Set (EuclideanSpace ℝ (Fin n) × ℝ) :=
  {p | p.1 ∈ D ∧ f p.1 ≥ p.2}