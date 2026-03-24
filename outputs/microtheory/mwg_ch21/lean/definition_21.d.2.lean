import Mathlib

/-- A linear order on X in the sense of MWG Definition 21.D.2:
    a binary relation that is reflexive, transitive, and total
    (for distinct elements, exactly one direction holds). -/
structure MWGLinearOrder (X : Type*) where
  /-- The "greater than or equal to" relation -/
  ge : X → X → Prop
  /-- Reflexivity: x ≥ x for every x -/
  refl : ∀ x : X, ge x x
  /-- Transitivity: x ≥ y and y ≥ z implies x ≥ z -/
  trans : ∀ x y z : X, ge x y → ge y z → ge x z
  /-- Totality: for any x, y, either x ≥ y or y ≥ x -/
  total : ∀ x y : X, ge x y ∨ ge y x
  /-- Antisymmetry: x ≥ y and y ≥ x implies x = y
      (captures the "not both" clause for distinct elements) -/
  antisymm : ∀ x y : X, ge x y → ge y x → x = y