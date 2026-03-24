import Mathlib

theorem Quotient_Epimorphism_is_Epimorphism_Ring (R : Type*) [CommRing R] (J : Ideal R) :
    let φ : R →+* R ⧸ J := Ideal.Quotient.mk J
    Function.Surjective φ ∧ RingHom.ker φ = J := by
  constructor
  · exact Ideal.Quotient.mk_surjective
  · exact Ideal.mk_ker