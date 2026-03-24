import Mathlib

open Set

theorem set_compl_diff_compl_eq_diff {α : Type*} (S T : Set α) : Sᶜ \ Tᶜ = T \ S := by
  ext x
  simp [mem_diff, mem_compl_iff, not_not, and_comm]