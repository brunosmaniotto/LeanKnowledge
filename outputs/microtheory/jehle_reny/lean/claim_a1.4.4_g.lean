import Mathlib

open Set
open Topology

variable {E : Type*} [AddCommMonoid E] [Module ℝ E]

theorem convexOn_imp_quasiconvexOn (s : Set E) (f : E → ℝ) (hs : Convex ℝ s)
    (hf : ConvexOn ℝ s f) : QuasiconvexOn ℝ s f :=
  hf.quasiconvexOn