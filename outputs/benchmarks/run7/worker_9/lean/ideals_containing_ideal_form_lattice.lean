import Mathlib

variable {R : Type u} [CommRing R] (J : Ideal R)

/-- The type of ideals of `R` that contain the ideal `J`. -/
def idealsContaining : Type u := { K : Ideal R // J ≤ K }

instance : PartialOrder (idealsContaining J) :=
  Subtype.partialOrder _

instance : Lattice (idealsContaining J) :=
  Subtype.lattice
    (fun a b ha hb => ha.trans (le_sup_left : a ≤ a ⊔ b))
    (fun a b ha hb => le_inf ha hb)