import Mathlib

/-- A rational preference relation on X: complete and transitive. -/
structure RationalPreference (X : Type*) where
  rel : X → X → Prop
  complete : ∀ x y : X, rel x y ∨ rel y x
  transitive : ∀ x y z : X, rel x y → rel y z → rel x z

/-- The strict preference derived from a rational preference relation:
    x is strictly preferred to y iff x ≥ y but not y ≥ x. -/
def RationalPreference.strict {X : Type*} (R : RationalPreference X) (x y : X) : Prop :=
  R.rel x y ∧ ¬R.rel y x

/-- A social welfare functional assigns a rational preference relation
    to every profile of individual utility functions on X.
    - I is the type indexing individuals
    - X is the set of alternatives
    - F maps a profile of utility functions (one per individual) to a rational preference
    - F_s is the derived strict preference relation -/
structure SocialWelfareFunctional (X : Type*) (I : Type*) where
  F : (I → X → ℝ) → RationalPreference X
  F_s : (I → X → ℝ) → X → X → Prop := fun profile x y => (F profile).strict x y