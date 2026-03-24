import Mathlib

noncomputable def quotient_ring_of_integers_and_zero : ℤ ⧸ Ideal.span {(0 : ℤ)} ≃+* ℤ := by
  have h : Ideal.span {(0 : ℤ)} = (⊥ : Ideal ℤ) := by simp
  rw [h]
  exact RingEquiv.quotientBot ℤ