import Mathlib

variable (G : Type*) [Group G]

open MulAut

/-- The subgroup of inner automorphisms of G. -/
def inner : Subgroup (MulAut G) :=
  (conj : G →* MulAut G).range