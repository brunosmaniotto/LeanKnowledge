import Mathlib

variable {G : Type*} [Group G] (N : Subgroup G) [N.Normal]

-- Define the correspondence from subgroups of G containing N to subgroups of G/N
def alpha (H : {H : Subgroup G // N ≤ H}) : Subgroup (G ⧸ N) :=
  H.val.map (QuotientGroup.mk' N)

-- Define the inverse correspondence from subgroups of G/N to subgroups of G containing N