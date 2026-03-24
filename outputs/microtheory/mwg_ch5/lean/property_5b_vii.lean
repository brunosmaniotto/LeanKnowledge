import Mathlib
open Topology

/-- A production set Y exhibits nonincreasing returns to scale if for any y ∈ Y,
    αy ∈ Y for all scalars α ∈ [0, 1]. -/
def nonincreasingReturnsToScale {n : ℕ} (Y : Set (Fin n → ℝ)) : Prop :=
  ∀ y ∈ Y, ∀ α : ℝ, 0 ≤ α → α ≤ 1 → α • y ∈ Y