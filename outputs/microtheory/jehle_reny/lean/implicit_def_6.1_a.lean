import Mathlib

/-- A social state is a mutually exclusive alternative that a society may
    collectively choose. Examples include election of a candidate, division
    of resources, or adoption of a form of societal organization.
    The carrier type represents the set of all possible social states. -/
structure SocialStates where
  /-- The underlying type of social states. -/
  carrier : Type*