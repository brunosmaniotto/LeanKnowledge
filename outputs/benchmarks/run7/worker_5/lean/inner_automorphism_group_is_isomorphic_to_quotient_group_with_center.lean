import Mathlib

variable (G : Type u) [Group G]

/-- The inner automorphism group of G, defined as the range of the conjugation homomorphism. -/
def innerAut : Subgroup (MulAut G) := (MulAut.conj : G →* MulAut G).range