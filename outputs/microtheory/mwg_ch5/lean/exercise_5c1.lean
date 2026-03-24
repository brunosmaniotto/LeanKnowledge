import Mathlib

noncomputable section

open scoped BigOperators

variable {ι : Type*} [Fintype ι]

def NDRS (Y : Set (ι → ℝ)) : Prop :=
  ∀ y ∈ Y, ∀ α : ℝ, 1 ≤ α → (fun i => α * y i) ∈ Y