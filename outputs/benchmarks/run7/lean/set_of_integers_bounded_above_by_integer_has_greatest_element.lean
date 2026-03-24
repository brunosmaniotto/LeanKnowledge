import Mathlib

open Set

theorem set_bdd_above_has_greatest (S : Set ℤ) (hne : S.Nonempty) (hbdd : BddAbove S) :
    ∃ x, IsGreatest S x :=
  Int.exists_greatest_of_bdd hbdd hne