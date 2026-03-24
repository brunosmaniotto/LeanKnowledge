import Mathlib

theorem quotient_mapping_surjection (S : Type u) (R : S → S → Prop) (h : Equivalence R) :
    Function.Surjective (Quot.mk R) :=
  λ q => Quot.exists_rep q