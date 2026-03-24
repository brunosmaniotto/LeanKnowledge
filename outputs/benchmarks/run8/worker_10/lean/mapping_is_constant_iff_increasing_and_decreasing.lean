import Mathlib

variable {S T : Type _} [PartialOrder T]

theorem constant_iff_forall_le_and_ge (φ : S → T) :
    (∀ x y, φ x = φ y) ↔ (∀ x y, φ x ≤ φ y) ∧ (∀ x y, φ y ≤ φ x) := by
  constructor
  · intro h
    constructor
    · intro x y
      exact le_of_eq (h x y)
    · intro x y
      exact le_of_eq (h x y).symm
  · intro ⟨h_le, h_ge⟩ x y
    exact le_antisymm (h_le x y) (h_ge x y)