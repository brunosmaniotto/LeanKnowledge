import Mathlib

-- Sub-lemmas
lemma direct_image_is_subset {S T : Type*} (R : Set (S × T)) (X : Set S) : 
  {t : T | ∃ s ∈ X, (s, t) ∈ R} ⊆ Set.univ := by
  exact Set.subset_univ _