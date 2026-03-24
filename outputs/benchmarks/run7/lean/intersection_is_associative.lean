import Mathlib

variable {α : Type*}

theorem inter_assoc (A B C : Set α) : A ∩ (B ∩ C) = (A ∩ B) ∩ C := by
  ext x
  simp only [Set.mem_inter_iff]
  exact and_assoc.symm