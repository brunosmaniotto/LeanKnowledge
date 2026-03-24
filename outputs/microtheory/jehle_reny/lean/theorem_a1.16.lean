import Mathlib

open scoped BigOperators
open Topology

theorem Theorem_A1_16 {D : Set ℝ} {f : ℝ → ℝ} (hD : Convex ℝ D) :
    (ConcaveOn ℝ D f ↔ ConvexOn ℝ D (-f)) ∧
    (StrictConcaveOn ℝ D f ↔ StrictConvexOn ℝ D (-f)) := by
  constructor
  · exact ⟨ConcaveOn.neg, fun h => by simpa using h.neg⟩
  · exact ⟨StrictConcaveOn.neg, fun h => by simpa using h.neg⟩