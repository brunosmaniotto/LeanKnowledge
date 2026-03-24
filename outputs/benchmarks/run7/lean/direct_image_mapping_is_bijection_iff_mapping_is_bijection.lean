import Mathlib

open Set

variable {S T : Type*} (R : Set (S × T))

def directImage : Set S → Set T := fun A => { y | ∃ x ∈ A, (x, y) ∈ R }

noncomputable def toFun (h : ∀ x, ∃! y, (x, y) ∈ R) : S → T := fun x => (Classical.choose (h x))