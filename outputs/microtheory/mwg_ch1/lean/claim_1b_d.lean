import Mathlib

def UtilityRepresents {X : Type*} (R : X → X → Prop) (u : X → ℝ) : Prop :=
  ∀ x y, R x y ↔ u x ≤ u y