import Mathlib
open Topology

/-- n-dimensional Euclidean space ℝⁿ, defined as the set product
    ℝ × ℝ × ⋯ × ℝ (n times). An element x = (x₁, ..., xₙ) is
    an n-tuple (vector) representing a point in ℝⁿ. -/
abbrev MWG.EuclideanNSpace (n : ℕ) : Type :=
  EuclideanSpace ℝ (Fin n)

/-- The Cartesian plane ℝ², i.e. two-dimensional Euclidean space. -/
abbrev MWG.CartesianPlane : Type :=
  MWG.EuclideanNSpace 2