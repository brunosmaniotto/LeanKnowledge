import Mathlib

open Set

theorem ring_epimorphism_preserves_ideals {R S : Type*} [Ring R] [Ring S]
    (f : R →+* S) (hf : Function.Surjective f) (J : Ideal R) :
    (Ideal.map f J : Set S) = f '' (J : Set R) := by
  ext x
  simp only [SetLike.mem_coe, Ideal.mem_map_iff_of_surjective f hf, mem_image]