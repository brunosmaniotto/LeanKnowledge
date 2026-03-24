import Mathlib

open Set

/-- Quasiconvexity is a weaker requirement than convexity:
    every convex function is quasiconvex. -/
theorem claim_A1_4_4_d {f : ℝ → ℝ} (hf : ConvexOn ℝ (Set.univ) f) :
    QuasiconvexOn ℝ (Set.univ) f :=
  hf.quasiconvexOn