import Mathlib

open Set
open Topology

/-- A concave function is automatically quasiconcave. -/
theorem concave_implies_quasiconcave
    {E : Type*} [AddCommMonoid E] [Module ℝ E]
    {s : Set E} {f : E → ℝ}
    (hs : Convex ℝ s) (hf : ConcaveOn ℝ s f) :
    QuasiconcaveOn ℝ s f := by
  exact hf.quasiconcaveOn