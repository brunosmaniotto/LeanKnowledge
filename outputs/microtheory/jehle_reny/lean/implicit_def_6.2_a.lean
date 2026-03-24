import Mathlib

/-- A non-empty set of mutually exclusive social states under consideration.
    Mutual exclusivity is inherent in the type-theoretic formulation:
    distinct elements of the carrier type represent distinct social states.
    X may be finite or infinite; no finiteness constraint is imposed by default. -/
structure SocialStates where
  /-- The underlying type of social states. -/
  carrier : Type*
  /-- The set of social states is non-empty. -/
  nonempty : Nonempty carrier