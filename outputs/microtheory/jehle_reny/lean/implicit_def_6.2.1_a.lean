import Mathlib

open Set
open Topology

/-- Setup for the diagrammatic proof of Arrow's theorem (MWG Definition 6.2.1):
    X is a non-singleton convex subset of ℝ^K (K ≥ 1) with infinitely many elements. -/
structure DiagrammaticArrowSetup where
  K : ℕ
  hK : K ≥ 1
  X : Set (EuclideanSpace ℝ (Fin K))
  convex : Convex ℝ X
  nontrivial : X.Nontrivial
  infinite : X.Infinite