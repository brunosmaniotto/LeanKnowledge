import Mathlib

open Real Topology Order BigOperators

variable {X : Type*} (ui : X → ℝ) (a : ℝ) (ha : a > 0) (hui_pos : ∀ x, ui x > 0)

-- Define what it means for a function `u` to be a utility function representing a preference `pref`.
def RepresentsPreferences {X : Type*} (u : X → ℝ) (pref : X → X → Prop) : Prop :=
  ∀ x y, pref x y ↔ u x ≥ u y

-- Define the transform function f
noncomputable def f_transform (a : ℝ) (y : ℝ) : ℝ := - y^(-a)

-- Prove the derivative of f_transform