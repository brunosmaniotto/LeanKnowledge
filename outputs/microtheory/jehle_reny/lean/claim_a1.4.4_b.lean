import Mathlib
open Topology

theorem claim_A1_4_4_b {E : Type*} [AddCommMonoid E] [Module ℝ E]
    {s : Set E} {f : E → ℝ} (hs : Convex ℝ s) :
    ConcaveOn ℝ s f ↔ ConvexOn ℝ s (-f) := by
  constructor
  · exact ConcaveOn.neg
  · intro h
    have := h.neg
    simp only [neg_neg] at this
    exact this