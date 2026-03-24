import Mathlib
open Topology

/-- A production set `Y` exhibits nondecreasing returns to scale if for any `y ∈ Y`
and any scalar `α ≥ 1`, we have `α • y ∈ Y`. -/
def NondecreasingReturnsToScale {n : ℕ} (Y : Set (Fin n → ℝ)) : Prop :=
  ∀ y ∈ Y, ∀ α : ℝ, 1 ≤ α → α • y ∈ Y