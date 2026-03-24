import Mathlib

variable {α : Type}

theorem transitive_iff_comp_subset (R : Set (α × α)) :
    (∀ (x y z : α), ((x, y) ∈ R ∧ (y, z) ∈ R) → (x, z) ∈ R) ↔
    (∀ (x z : α), (∃ y, (x, y) ∈ R ∧ (y, z) ∈ R) → (x, z) ∈ R) := by
  constructor
  · intro h x z hxz
    rcases hxz with ⟨y, hxy, hyz⟩
    exact h x y z ⟨hxy, hyz⟩
  · intro h x y z ⟨hxy, hyz⟩
    exact h x z ⟨y, hxy, hyz⟩