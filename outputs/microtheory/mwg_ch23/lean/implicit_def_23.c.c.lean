import Mathlib

variable {X : Type*} [DecidableEq X] {I : Type*} {Θ : I → Type*}

def StrictRationalPrefs (X : Type*) : Set (X → X → Prop) :=
  {R | (∀ x y, R x y ∨ R y x) ∧
       (∀ x y z, R x y → R y z → R x z) ∧
       (∀ x y, R x y → R y x → x = y)}