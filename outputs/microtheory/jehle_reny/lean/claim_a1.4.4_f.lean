import Mathlib

open Set
open Topology

variable {E : Type*} [AddCommMonoid E] [Module ℝ E]

-- Part 5: concave implies quasiconcave
theorem concaveOn_imp_quasiconcaveOn (s : Set E) (f : E → ℝ) (hs : Convex ℝ s)
    (hf : ConcaveOn ℝ s f) : QuasiconcaveOn ℝ s f :=
  hf.quasiconcaveOn

-- Part 6: convex implies quasiconvex