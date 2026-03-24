import Mathlib

variable (D : Type*) [CommRing D] [IsDomain D]

/-- Two elements are associates if each divides the other. -/
def Associate (x y : D) : Prop := x ∣ y ∧ y ∣ x