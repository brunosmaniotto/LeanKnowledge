import Mathlib
open Topology

/-- The direct utility function: a utility function u : X → ℝ defined over
    the consumption set X that represents the consumer's preferences directly
    (as opposed to the indirect utility function defined over prices and wealth). -/
structure DirectUtilityFunction (X : Type*) where
  /-- The preference relation ≿ on X. -/
  pref : X → X → Prop
  /-- The utility function u : X → ℝ. -/
  u : X → ℝ
  /-- u represents ≿: x ≿ y ↔ u(x) ≥ u(y). -/
  represents : ∀ x y : X, pref x y ↔ u y ≤ u x