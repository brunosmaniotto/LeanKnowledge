import Mathlib

variable {G : Type*} [Group G] (N : Subgroup G) [N.Normal]

theorem coset_product_well_defined (a a' b b' : G) 
    (ha : (a : G ⧸ N) = (a' : G ⧸ N)) 
    (hb : (b : G ⧸ N) = (b' : G ⧸ N)) : 
    (a * b : G ⧸ N) = (a' * b' : G ⧸ N) := by
  rw [ha, hb]