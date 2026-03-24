import Mathlib

-- The uniqueness lemma (provided)
lemma fraction_field_extension_unique {R S K L : Type*} [CommRing R] [CommRing S] [Field K] [Field L] 
  [Algebra R K] [IsFractionRing R K] [Algebra S L] [IsFractionRing S L] 
  (φ : R →+* S) (ψ₁ ψ₂ : K →+* L) 
  (h₁ : ∀ x : R, ψ₁ (algebraMap R K x) = algebraMap S L (φ x)) 
  (h₂ : ∀ x : R, ψ₂ (algebraMap R K x) = algebraMap S L (φ x)) : 
  ψ₁ = ψ₂ := by
  apply IsFractionRing.ringHom_ext (A := R)
  intro x
  rw [h₁, h₂]

-- Main theorem