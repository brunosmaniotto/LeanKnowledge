import Mathlib

theorem set_double_diff_chain {α : Type*} (S T : Set α) :
    S \ (S \ T) = S ∩ T ∧ S ∩ T = T \ (T \ S) := by
  constructor
  · ext x
    simp only [Set.mem_diff, Set.mem_inter_iff]
    tauto
  · ext x
    simp only [Set.mem_diff, Set.mem_inter_iff]
    tauto