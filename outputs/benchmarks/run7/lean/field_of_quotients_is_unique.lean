import Mathlib

-- The provided sub-lemma
lemma fraction_field_algebra_map_injective {D : Type*} [CommRing D] [IsDomain D] {K : Type*} [Field K] [Algebra D K] [IsFractionRing D K] : Function.Injective (algebraMap D K) := by
  exact IsFractionRing.injective D K

-- Key lemma: existence of isomorphism between fraction fields