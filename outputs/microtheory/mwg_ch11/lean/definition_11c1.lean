import Mathlib
open Topology

-- A type representing the agents (individuals) who can use the good.
-- We assume `Agent` is non-empty to ensure there's at least one agent.
variable (Agent : Type) [Inhabited Agent]

-- A type representing a single unit of the commodity (good).
-- We assume `UnitOfGood` is non-empty to ensure there's at least one unit.
variable (UnitOfGood : Type) [Inhabited UnitOfGood]

-- A predicate `uses a u` which is true if agent `a` uses unit `u` of the good.
-- This predicate captures the act or state of an agent deriving benefit from a unit.
variable (uses : Agent → UnitOfGood → Prop)

/--
A public good is a commodity for which use of a unit of the good by one agent
does not preclude its use by other agents.
Equivalently, public goods are nondepletable: consumption by one individual
does not affect the supply available for other individuals.

This definition captures the non-rivalrous nature of a public good.
If one agent `a1` uses a unit `u` of the good, it implies that any other agent `a2`
can also use the same unit `u` without their ability to use it being diminished or prevented.
In Lean's timeless `Prop` system, "does not preclude" for propositions `P` and `Q` means `P → Q`.
Thus, if `a1` uses `u`, then `a2` can also use `u`.
-/
def IsPublicGood : Prop :=
  ∀ (u : UnitOfGood) (a1 a2 : Agent), (uses a1 u) → (uses a2 u)