import Mathlib

variable {α : Type*} {S T : Set α}

theorem set_eq_iff_diff_both_empty : S = T ↔ S \ T = ∅ ∧ T \ S = ∅ := by
  constructor
  · intro h
    subst h
    exact ⟨by simp, by simp⟩
  · rintro ⟨hST, hTS⟩
    have h1 : S ⊆ T := Set.diff_eq_empty.mp hST
    have h2 : T ⊆ S := Set.diff_eq_empty.mp hTS
    exact Set.Subset.antisymm h1 h2