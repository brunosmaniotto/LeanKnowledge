import Mathlib

variable {G : Type*} [Group G] (S : Set G) (a : G)

-- Define the normalizer of a set
def setNormalizer (T : Set G) : Set G := {x : G | ∀ t ∈ T, x * t * x⁻¹ ∈ T ∧ x⁻¹ * t * x ∈ T}

-- Define conjugate of a set