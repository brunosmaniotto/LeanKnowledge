import Mathlib
open Topology

/-- Property (xii): Y is a convex cone. For any y, y' ∈ Y and constants α ≥ 0, β ≥ 0,
    we have α • y + β • y' ∈ Y. This is the conjunction of convexity and constant
    returns to scale. -/
def IsConvexCone {n : ℕ} (Y : Set (Fin n → ℝ)) : Prop :=
  ∀ y ∈ Y, ∀ y' ∈ Y, ∀ α β : ℝ, 0 ≤ α → 0 ≤ β → α • y + β • y' ∈ Y