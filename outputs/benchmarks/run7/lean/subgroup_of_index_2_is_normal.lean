import Mathlib

open Subgroup

theorem index_two_subgroup_normal (G : Type*) [Group G] (H : Subgroup G) (h : H.index = 2) : H.Normal :=
  normal_of_index_eq_two h