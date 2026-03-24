import Mathlib

-- Sub-lemmas
lemma univ_diff_eq_compl {α : Type*} (s : Set α) : Set.univ \ s = sᶜ := by
  ext x
  simp [Set.mem_diff, Set.mem_compl_iff]