import Mathlib

open Function

theorem inverse_element {S T : Type*} (f : S → T) (hf : Bijective f) (x : S) (y : T) :
    (Equiv.ofBijective f hf).symm y = x ↔ f x = y := by
  rw [Equiv.symm_apply_eq, Equiv.ofBijective_apply]
  exact ⟨fun h => h.symm, fun h => h.symm⟩