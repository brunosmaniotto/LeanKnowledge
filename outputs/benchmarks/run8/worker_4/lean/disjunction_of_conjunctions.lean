import Mathlib

theorem disjunction_of_conjunctions (p q r s : Prop) : (p ∧ q) ∨ (r ∧ s) → p ∨ r := by
  intro h
  rcases h with (⟨hp, _⟩ | ⟨hr, _⟩)
  · exact Or.inl hp
  · exact Or.inr hr