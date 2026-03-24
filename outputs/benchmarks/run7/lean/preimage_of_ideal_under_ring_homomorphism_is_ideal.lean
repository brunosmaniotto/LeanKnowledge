import Mathlib

theorem ker_le_comap (R₁ R₂ : Type*) [Semiring R₁] [Semiring R₂] 
    (f : R₁ →+* R₂) (J : Ideal R₂) : RingHom.ker f ≤ Ideal.comap f J := by
  intro x hx
  rw [RingHom.mem_ker] at hx
  rw [Ideal.mem_comap]
  rw [hx]
  exact J.zero_mem