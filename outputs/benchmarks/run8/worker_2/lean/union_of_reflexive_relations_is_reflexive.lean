import Mathlib

theorem reflexive_union {α : Type} {R S : Set (α × α)} (hR : ∀ a, (a, a) ∈ R) (hS : ∀ a, (a, a) ∈ S) :
    ∀ a, (a, a) ∈ R ∪ S := by
  intro a
  exact Or.inl (hR a)