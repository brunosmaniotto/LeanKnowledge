import Mathlib

theorem kernel_is_ideal {R₁ R₂ : Type*} [Semiring R₁] [Semiring R₂] (φ : R₁ →+* R₂) : 
  ∃ I : Ideal R₁, I = RingHom.ker φ := 
⟨RingHom.ker φ, rfl⟩