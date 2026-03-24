import Mathlib

universe u

structure PreferenceRelation (X : Type u) where
  pref : X → X → Prop

structure IsRational {X : Type u} (R : PreferenceRelation X) where
  complete : ∀ x y : X, R.pref x y ∨ R.pref y x
  transitive : ∀ x y z : X, R.pref x y → R.pref y z → R.pref x z

def RepresentedBy {X : Type u} (R : PreferenceRelation X) (u : X → ℝ) : Prop :=
  ∀ x y : X, R.pref x y ↔ u x ≥ u y