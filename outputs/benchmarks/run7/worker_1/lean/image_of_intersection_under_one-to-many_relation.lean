import Mathlib

variable {S T : Type*}

/-- A relation `R : Set (S × T)` is one-to-many if every element of `T` is related to at most one
element of `S`. -/
def one_to_many (R : Set (S × T)) : Prop :=
  ∀ (x y : S) (z : T), (x, z) ∈ R → (y, z) ∈ R → x = y

open Set