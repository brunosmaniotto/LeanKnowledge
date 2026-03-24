import Mathlib

-- Sub-lemmas
lemma union_empty_eq_self {α : Type*} (S : Set α) : S ∪ ∅ = S := by
  exact Set.union_empty S