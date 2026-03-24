import Mathlib

theorem disjunction_of_conditional_and_converse (p q : Prop) : (p → q) ∨ (q → p) := by
  by_cases h : p
  · right
    intro _
    exact h
  · left
    intro hp
    exfalso
    exact h hp