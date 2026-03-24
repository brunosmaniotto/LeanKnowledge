import Mathlib

variable {α : Type _} (R S T : Set α)

theorem union_distrib_over_inter : R ∪ (S ∩ T) = (R ∪ S) ∩ (R ∪ T) := by
  ext x
  simp only [Set.mem_union, Set.mem_inter_iff]
  exact or_and_left