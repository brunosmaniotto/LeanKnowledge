import Mathlib

theorem identity_mapping_bijective (S : Type _) : Function.Bijective (id : S → S) := by
  exact ⟨Function.injective_id, Function.surjective_id⟩