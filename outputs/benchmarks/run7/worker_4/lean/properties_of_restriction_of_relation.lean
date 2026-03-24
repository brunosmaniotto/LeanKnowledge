import Mathlib

variable {S : Type*} (R : S → S → Prop) (T : Set S)

/-- Restriction of relation R to set T as a relation on the subtype T. -/
def restriction : T → T → Prop := fun x y => R (x : S) (y : S)