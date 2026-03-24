import Mathlib

variable {S : Type} (R : S → S → Prop)
variable (h_refl : ∀ x, R x x) (h_symm : ∀ x y, R x y → R y x) (h_trans : ∀ x y z, R x y → R y z → R x z)

def equivClass (x : S) : Set S := {y | R x y}