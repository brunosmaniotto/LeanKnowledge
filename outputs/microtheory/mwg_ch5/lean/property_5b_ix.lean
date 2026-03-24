import Mathlib
open Topology

def constantReturnsToScale {n : ℕ} (Y : Set (Fin n → ℝ)) : Prop :=
  ∀ y ∈ Y, ∀ α : ℝ, α > 0 → α • y ∈ Y