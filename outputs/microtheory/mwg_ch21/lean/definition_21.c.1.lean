import Mathlib

universe u

/-- A rational preference relation on a type `X`: complete and transitive. -/
structure RationalPreference (X : Type u) where
  rel : X → X → Prop
  complete : ∀ x y : X, rel x y ∨ rel y x
  trans : ∀ x y z : X, rel x y → rel y z → rel x z

/-- A social welfare functional (Definition 21.C.1).
    Given a set of individuals `I` and alternatives `X`,
    it maps preference profiles from an admissible domain `A ⊆ (I → RationalPreference X)`
    to a social rational preference relation. -/
structure SocialWelfareFunctional (X : Type u) (I : Type*) where
  /-- The admissible domain A ⊂ Rᴵ (a set of preference profiles) -/
  domain : Set (I → RationalPreference X)
  /-- The aggregation rule F : A → R -/
  aggregate : { profile // profile ∈ domain } → RationalPreference X