import Mathlib

variable {G : Type} [Group G] (S : Set G)

def normalizer (S : Set G) : Set G := 
  {g : G | ∀ s ∈ S, g * s * g⁻¹ ∈ S ∧ ∀ t ∈ S, ∃ s ∈ S, t = g * s * g⁻¹}