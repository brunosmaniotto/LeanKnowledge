import Mathlib

open Subgroup

/-- A subgroup of an abelian (commutative) group is itself abelian. -/
instance {G : Type} [CommGroup G] (H : Subgroup G) : CommGroup H :=
  { Subgroup.toGroup H with
    mul_comm := fun a b ↦ Subtype.ext (mul_comm (a : G) (b : G)) }