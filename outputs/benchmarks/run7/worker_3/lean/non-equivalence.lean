import Mathlib

open Classical

theorem not_iff_imp_not_or_not (p q : Prop) : ¬ (p ↔ q) ↔ ¬ (p → q) ∨ ¬ (q → p) := by
  constructor
  · intro h
    by_cases hpq : p → q
    · by_cases hqp : q → p
      · exfalso
        exact h ⟨hpq, hqp⟩
      · exact Or.inr hqp
    · exact Or.inl hpq
  · intro h h_iff
    rcases h with (hnpq | hnqp)
    · exact hnpq h_iff.1
    · exact hnqp h_iff.2