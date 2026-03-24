import Mathlib

lemma quotient_ker_hom_exists {R₁ R₂ : Type*} [CommRing R₁] [CommRing R₂] (φ : R₁ →+* R₂) (hφ : Function.Surjective φ) : 
  ∃ (g : R₁ ⧸ RingHom.ker φ →+* R₂), ∀ x, g (Ideal.Quotient.mk (RingHom.ker φ) x) = φ x := by
  use Ideal.Quotient.lift (RingHom.ker φ) φ (fun x hx => hx)
  intro x
  rw [Ideal.Quotient.lift_mk]