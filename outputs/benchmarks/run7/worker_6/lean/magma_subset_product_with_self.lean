import Mathlib

open Set

theorem Magma_Subset_Product_with_Self {S : Type} [Mul S] (T : Set S) :
    (∀ x ∈ T, ∀ y ∈ T, x * y ∈ T) ↔ Set.image2 (· * ·) T T ⊆ T := by
  rw [Set.image2_subset_iff]