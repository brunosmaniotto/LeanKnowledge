import Mathlib

open Set

theorem intersection_distributes_over_union (R S T : Set α) : R ∩ (S ∪ T) = (R ∩ S) ∪ (R ∩ T) := by
  ext x
  simp only [mem_inter_iff, mem_union]
  tauto