import Mathlib

open Topology

/-- A continuous utility representation of a preference relation on a topological space X.
    The preference R is represented by a continuous function u : X → ℝ, meaning
    x R y ↔ u(x) ≥ u(y). -/
structure ContinuousUtilityRepresentation (X : Type*) [TopologicalSpace X] where
  /-- The preference relation on X -/
  pref : X → X → Prop
  /-- The utility function representing the preference -/
  u : X → ℝ
  /-- The utility function represents the preference: x ≿ y ↔ u(x) ≥ u(y) -/
  represents : ∀ x y, pref x y ↔ u y ≤ u x
  /-- The utility function is continuous -/
  u_continuous : Continuous u