import Mathlib

open Subgroup

variable {G : Type*} [Group G]

theorem Index_of_Intersection_of_Subgroups (H K : Subgroup G) : (H ⊓ K).index ≤ H.index * K.index :=
  index_inf_le