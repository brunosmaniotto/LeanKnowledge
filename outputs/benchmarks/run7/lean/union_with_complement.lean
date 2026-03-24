import Mathlib

open Set

theorem union_complement_self (S : Set α) : S ∪ Sᶜ = Set.univ := by
  ext x
  simp only [mem_union, mem_compl_iff, mem_univ]
  tauto