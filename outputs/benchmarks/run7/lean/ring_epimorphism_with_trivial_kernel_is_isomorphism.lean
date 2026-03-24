import Mathlib

variable {R₁ R₂ : Type _} [Ring R₁] [Ring R₂]

theorem ringEpimorphism_is_isomorphism_iff_ker_eq_bot (φ : R₁ →+* R₂) (hφ : Function.Surjective φ) :
    Function.Bijective φ ↔ RingHom.ker φ = ⊥ := by
  simp only [Function.Bijective, hφ, and_true, RingHom.injective_iff_ker_eq_bot]