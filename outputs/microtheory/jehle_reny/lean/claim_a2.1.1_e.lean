import Mathlib

open Set
open Topology

theorem Claim_A2_1_1_e {D : Set ℝ} (hD : Convex ℝ D) (f : ℝ → ℝ) :
    ConvexOn ℝ D f ↔ ConcaveOn ℝ D (-f) := by
  constructor
  · exact fun h => h.neg
  · intro h
    have := h.neg
    simp at this
    exact this