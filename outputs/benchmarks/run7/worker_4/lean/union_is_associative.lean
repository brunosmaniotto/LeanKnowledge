import Mathlib

variable {α : Type _}

theorem set_union_assoc (A B C : Set α) : A ∪ (B ∪ C) = (A ∪ B) ∪ C := by
  ext x
  simp only [Set.mem_union]
  exact or_assoc.symm