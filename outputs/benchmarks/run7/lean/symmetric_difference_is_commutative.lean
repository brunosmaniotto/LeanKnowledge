import Mathlib

-- Sub-lemmas
lemma symm_diff_def_unfold {α : Type*} (S T : Set α) : (S \ T) ∪ (T \ S) = (S \ T) ∪ (T \ S) := by
  rfl