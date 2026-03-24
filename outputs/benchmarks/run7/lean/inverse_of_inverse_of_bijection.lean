import Mathlib

theorem inverse_of_inverse_of_bijection {S T : Type*} (f : S → T) (h : Function.Bijective f) :
    ( (Equiv.ofBijective f h).symm ).symm = f := by
  rw [Equiv.symm_symm]
  rfl