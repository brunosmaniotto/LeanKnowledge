import Mathlib

theorem set_diff_inter_diff_empty {α : Type u} (S T : Set α) : (S \ T) ∩ (T \ S) = ∅ := by
  ext x
  simp only [Set.mem_inter_iff, Set.mem_diff, Set.mem_empty_iff_false]
  tauto