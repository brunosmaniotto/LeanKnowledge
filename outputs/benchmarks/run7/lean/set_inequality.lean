import Mathlib

theorem set_inequality {α : Type*} (S T : Set α) : S ≠ T ↔ ¬(S ⊆ T) ∨ ¬(T ⊆ S) := by
  constructor
  · intro h_ne
    by_cases h_st : S ⊆ T
    · by_cases h_ts : T ⊆ S
      · exfalso
        exact h_ne (Set.Subset.antisymm h_st h_ts)
      · exact Or.inr h_ts
    · exact Or.inl h_st
  · intro h_or h_eq
    cases' h_or with h_not_st h_not_ts
    · exact h_not_st h_eq.le
    · exact h_not_ts h_eq.ge