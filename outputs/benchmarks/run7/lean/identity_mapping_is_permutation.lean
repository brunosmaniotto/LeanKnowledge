import Mathlib

open Function

theorem identity_mapping_is_permutation (S : Type*) : ∃ f : Equiv.Perm S, ∀ x : S, f x = x :=
  ⟨Equiv.refl S, λ x => rfl⟩