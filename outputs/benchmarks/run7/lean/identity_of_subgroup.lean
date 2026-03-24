import Mathlib

theorem identity_of_subgroup (G : Type*) [Group G] (e : G) (he : e = 1) (H : Subgroup G) : ↑(1 : H) = e := by
  rw [H.coe_one, he.symm]