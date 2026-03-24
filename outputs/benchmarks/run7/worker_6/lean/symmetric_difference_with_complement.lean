import Mathlib

-- Sub-lemmas
lemma union_with_complement_is_univ {α : Type*} (S : Set α) : S ∪ Sᶜ = Set.univ := by
  ext x
  simp [Set.mem_union, Set.mem_compl_iff, Set.mem_univ]