import Mathlib

/-- Property (x): Additivity (free entry). A production set Y satisfies additivity
if for any y ∈ Y and y' ∈ Y, we have y + y' ∈ Y. -/
def Additivity {L : Type*} [AddCommMonoid L] (Y : Set L) : Prop :=
  ∀ y y' : L, y ∈ Y → y' ∈ Y → y + y' ∈ Y