import Mathlib

open Set

theorem Power_Set_is_Closed_under_Intersection {α : Type} (S : Set α) (A B : Set α)
    (hA : A ∈ 𝒫 S) (hB : B ∈ 𝒫 S) : A ∩ B ∈ 𝒫 S := by
  -- `hA : A ⊆ S` and `hB : B ⊆ S` by definition of `𝒫 S`
  -- We need to show `A ∩ B ⊆ S`
  intro x hx
  -- `hx : x ∈ A ∩ B` gives `x ∈ A` and `x ∈ B`
  exact hA hx.left