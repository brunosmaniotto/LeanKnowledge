import Mathlib

variable {G : Type*} [Group G]

theorem conjugacy_is_equivalence : Equivalence (@IsConj G _) :=
  { refl := IsConj.refl
    symm := fun h => IsConj.symm h
    trans := fun h₁ h₂ => IsConj.trans h₁ h₂ }