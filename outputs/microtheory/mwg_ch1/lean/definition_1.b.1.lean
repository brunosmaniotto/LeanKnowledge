import Mathlib

/-- Definition 1.B.1 (MWG): A rational preference relation on `X`. -/
structure RationalPreference (X : Type*) where
  /-- The weak preference relation ≿ -/
  pref : X → X → Prop
  /-- Completeness: for all x, y ∈ X, x ≿ y or y ≿ x -/
  complete : ∀ x y, pref x y ∨ pref y x
  /-- Transitivity: x ≿ y and y ≿ z imply x ≿ z -/
  trans : ∀ x y z, pref x y → pref y z → pref x z