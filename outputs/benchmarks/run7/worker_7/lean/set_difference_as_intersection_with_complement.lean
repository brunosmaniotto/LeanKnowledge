import Mathlib

open Set

theorem set_diff_eq_inter_compl (A B : Set α) : A \ B = A ∩ Bᶜ := by
  ext x
  simp only [mem_diff, mem_inter_iff, mem_compl_iff]