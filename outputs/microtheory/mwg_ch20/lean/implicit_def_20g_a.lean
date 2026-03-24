import Mathlib

/-- Classification of equilibrium properties: internal (referring to the structure
    of an equilibrium in isolation, e.g., convergence to steady state) versus
    external (referring to how an equilibrium relates to other possible equilibrium
    trajectories, e.g., uniqueness or local uniqueness). -/
inductive EquilibriumPropertyKind where
  | internal : EquilibriumPropertyKind
  | external : EquilibriumPropertyKind
deriving DecidableEq, Repr

/-- An equilibrium property bundled with its classification as internal or external. -/
structure EquilibriumProperty (α : Type*) where
  /-- The property as a predicate on equilibria -/
  property : α → Prop
  /-- Whether this property is internal or external -/
  kind : EquilibriumPropertyKind