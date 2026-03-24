import Mathlib
open Topology

/-- A set S ⊂ ℝⁿ is convex if for all x¹, x² ∈ S and t ∈ [0,1],
    the convex combination tx¹ + (1−t)x² ∈ S. -/
abbrev MWG.IsStrictlyConvex {n : ℕ} (S : Set (EuclideanSpace ℝ (Fin n))) : Prop :=
  Convex ℝ S