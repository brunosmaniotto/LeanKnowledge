import Mathlib

-- Sub-lemma 1: FractionRing is a field
noncomputable instance fraction_ring_is_field (D : Type*) [CommRing D] [IsDomain D] : Field (FractionRing D) :=
  inferInstance

-- Sub-lemma 2: algebraMap is injective
lemma algebra_map_injective (D : Type*) [CommRing D] [IsDomain D] : Function.Injective (algebraMap D (FractionRing D)) := by
  exact IsFractionRing.injective D (FractionRing D)

-- Sub-lemma 3: Universal property of fraction ring