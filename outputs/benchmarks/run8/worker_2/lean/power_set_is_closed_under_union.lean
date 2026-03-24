import Mathlib

theorem power_set_closed_under_union {α : Type*} (S : Set α) (A B : Set α)
    (hA : A ∈ Set.powerset S) (hB : B ∈ Set.powerset S) : A ∪ B ∈ Set.powerset S := by
  -- `hA : A ⊆ S` and `hB : B ⊆ S` by definition of `Set.powerset`
  exact Set.union_subset hA hB