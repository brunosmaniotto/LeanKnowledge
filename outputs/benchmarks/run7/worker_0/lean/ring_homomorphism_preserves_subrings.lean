import Mathlib

theorem ring_hom.image_subring {R S : Type*} [Ring R] [Ring S] (φ : R →+* S) (T : Subring R) :
    (T.map φ : Set S) = φ '' (T : Set R) := by
  ext x
  simp [Subring.mem_map]