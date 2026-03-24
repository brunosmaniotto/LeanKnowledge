import Mathlib

lemma bijective_iff_injective_and_surjective {S T : Type*} (f : S → T) : 
  Function.Bijective f ↔ Function.Injective f ∧ Function.Surjective f := by
  constructor
  · intro h
    exact ⟨h.1, h.2⟩
  · intro ⟨hinj, hsurj⟩
    exact ⟨hinj, hsurj⟩