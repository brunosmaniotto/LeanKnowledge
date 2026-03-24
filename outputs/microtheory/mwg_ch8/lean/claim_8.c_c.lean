import Mathlib

universe u

variable {I : Type*} [Fintype I] [DecidableEq I]
variable {S : I → Type*} [∀ i, Fintype (S i)] [∀ i, DecidableEq (S i)]

def IsBRClosed (br : ∀ i, S i → (∀ j, Set (S j)) → Prop) (R : ∀ j, Set (S j)) : Prop :=
  ∀ j sj, sj ∈ R j → br j sj R