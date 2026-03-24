import Mathlib
open scoped Pointwise
open Set

variable {G : Type} [Mul G]

theorem product_of_subset_with_intersection_left (X Y Z : Set G) :
    X * (Y ∩ Z) ⊆ (X * Y) ∩ (X * Z) := by
  intro g hg
  rcases hg with ⟨x, hx, w, ⟨hwY, hwZ⟩, rfl⟩
  constructor
  · exact ⟨x, hx, w, hwY, rfl⟩
  · exact ⟨x, hx, w, hwZ, rfl⟩