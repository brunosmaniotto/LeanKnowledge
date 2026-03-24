import Mathlib

-- Helper lemma: injective ring homomorphisms preserve non-zero elements
lemma phi_maps_nonzero_to_nonzero {R S : Type*} [CommRing R] [CommRing S] [IsDomain R] [IsDomain S] 
    (φ : R →+* S) (hφ : Function.Injective φ) : ∀ x : R, x ≠ 0 → φ x ≠ 0 := by
  intro x hx h
  have : φ x = φ 0 := by rw [map_zero, h]
  have : x = 0 := hφ this
  exact hx this

-- Extension exists and is unique