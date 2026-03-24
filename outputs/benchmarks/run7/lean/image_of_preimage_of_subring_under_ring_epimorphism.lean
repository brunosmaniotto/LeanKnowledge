import Mathlib

theorem ringEpimorphism_image_preimage {R S : Type*} [Ring R] [Ring S] 
    (φ : R →+* S) (hφ : Function.Surjective φ) (T : Subring S) :
    φ '' (φ ⁻¹' (T : Set S)) = (T : Set S) :=
  hφ.image_preimage (T : Set S)