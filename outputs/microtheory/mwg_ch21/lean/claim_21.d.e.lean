import Mathlib

open Finset

/-- Pairwise majority voting: x is weakly preferred to y under F if
    the number of voters who strictly prefer x to y is at least
    the number who strictly prefer y to x. -/
def majorityPrefers {I : Type*} [Fintype I] [DecidableEq I]
    (strict : I → α → α → Prop) [∀ i x y, Decidable (strict i x y)]
    (x y : α) : Prop :=
  (univ.filter fun i => strict i y x).card ≤ (univ.filter fun i => strict i x y).card