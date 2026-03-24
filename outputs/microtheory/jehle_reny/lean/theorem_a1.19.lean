import Mathlib

open Set
open Topology

/-- A function is quasiconvex on a convex set if for all x, y in the set and t ∈ [0,1],
    f(t*x + (1-t)*y) ≤ max(f(x), f(y)) -/
def IsQuasiconvexOn (f : ℝ → ℝ) (s : Set ℝ) : Prop :=
  ConvexOn ℝ s f ∨  -- placeholder: we define it directly
  ∀ x ∈ s, ∀ y ∈ s, ∀ t : ℝ, 0 ≤ t → t ≤ 1 →
    f (t * x + (1 - t) * y) ≤ max (f x) (f y)