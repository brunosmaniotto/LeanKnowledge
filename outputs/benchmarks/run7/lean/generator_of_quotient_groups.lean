import Mathlib

open QuotientGroup

variable {G : Type*} [Group G] (N A B : Subgroup G) [N.Normal] (hNA : N ≤ A) (hNB : N ≤ B)

/-- The map sending a subgroup `H` of `G` to the subgroup `{hN | h ∈ H}` of `G/N`. -/
def α (H : Subgroup G) : Subgroup (G ⧸ N) :=
  H.map (mk' N)