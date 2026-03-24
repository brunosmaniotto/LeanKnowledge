import Mathlib

open Set Pointwise

/-- The set difference C = A - B (Minkowski difference) of two convex sets A and B is convex. -/
theorem claim_A2_5_a {E : Type*} [AddCommGroup E] [Module ℝ E]
    (A B : Set E) (hA : Convex ℝ A) (hB : Convex ℝ B) :
    Convex ℝ (A - B) :=
  hA.sub hB