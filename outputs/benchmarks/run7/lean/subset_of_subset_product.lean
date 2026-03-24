import Mathlib

open Set

variable {S : Type} [Mul S] {X Y Z : Set S}

theorem subset_of_subset_product (h : X ⊆ Y) :
    Set.image2 (· * ·) X Z ⊆ Set.image2 (· * ·) Y Z ∧
    Set.image2 (· * ·) Z X ⊆ Set.image2 (· * ·) Z Y := by
  constructor
  · exact Set.image2_subset_right h
  · exact Set.image2_subset_left h