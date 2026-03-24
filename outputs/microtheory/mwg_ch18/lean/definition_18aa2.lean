import Mathlib

/-- A game in characteristic form (coalitional game). -/
structure CharacteristicFormGame (I : Type*) [Fintype I] where
  /-- For each coalition S, the utility possibility set V(S) ⊆ ℝ^S -/
  V : Finset I → Set (Finset I → ℝ)