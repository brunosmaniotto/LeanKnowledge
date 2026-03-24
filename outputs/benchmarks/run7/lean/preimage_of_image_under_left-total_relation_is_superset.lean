import Mathlib

theorem preimage_image_superset {S T : Type*} (R : Set (S × T)) (A : Set S)
    (h_left_total : ∀ x : S, ∃ y : T, (x, y) ∈ R) : A ⊆ { z | ∃ a ∈ A, ∃ y, (a, y) ∈ R ∧ (z, y) ∈ R } := by
  intro x hx
  rcases h_left_total x with ⟨y, hy⟩
  exact ⟨x, hx, y, hy, hy⟩