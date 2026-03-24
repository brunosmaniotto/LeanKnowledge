import Mathlib

theorem identity_surjective (S : Type*) : Function.Surjective (id : S → S) := by
  intro y
  exact ⟨y, rfl⟩