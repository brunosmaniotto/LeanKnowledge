import Mathlib

-- Sub-lemma 1
lemma union_diff_eq_diff_inter_union (S T : Set α) : (S \ T) ∪ (T \ S) = (S \ (S ∩ T)) ∪ (T \ (S ∩ T)) := by
  ext x
  simp only [Set.mem_union, Set.mem_diff, Set.mem_inter_iff]
  constructor
  · intro h
    cases h with
    | inl h => 
      left
      exact ⟨h.1, fun hx => h.2 hx.2⟩
    | inr h =>
      right
      exact ⟨h.1, fun hx => h.2 hx.1⟩
  · intro h
    cases h with
    | inl h =>
      left
      exact ⟨h.1, fun ht => h.2 ⟨h.1, ht⟩⟩
    | inr h =>
      right
      exact ⟨h.1, fun hs => h.2 ⟨hs, h.1⟩⟩

-- Sub-lemma 2