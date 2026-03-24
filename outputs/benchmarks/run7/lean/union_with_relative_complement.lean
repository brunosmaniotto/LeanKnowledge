import Mathlib

variable {α : Type _} {S T : Set α}

theorem union_compl_self (h : T ⊆ S) : (S \ T) ∪ T = S := by
  ext x
  constructor
  · intro hx
    rcases hx with (hx | hx)
    · exact hx.1
    · exact h hx
  · intro hx
    by_cases hxT : x ∈ T
    · exact Or.inr hxT
    · exact Or.inl ⟨hx, hxT⟩