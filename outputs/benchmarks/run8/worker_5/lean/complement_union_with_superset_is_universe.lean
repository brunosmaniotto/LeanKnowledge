import Mathlib

open Set

theorem subset_iff_union_compl_eq_univ (S T : Set α) : S ⊆ T ↔ Sᶜ ∪ T = Set.univ := by
  constructor
  · intro h
    rw [Set.eq_univ_iff_forall]
    intro x
    by_cases hx : x ∈ S
    · exact Or.inr (h hx)
    · exact Or.inl hx
  · intro h x hx
    have h_mem : x ∈ Sᶜ ∪ T := (Set.eq_univ_iff_forall.mp h) x
    rcases h_mem with (h' | h'')
    · exfalso
      exact h' hx
    · exact h''