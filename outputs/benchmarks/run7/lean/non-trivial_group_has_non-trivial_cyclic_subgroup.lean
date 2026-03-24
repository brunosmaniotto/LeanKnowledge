import Mathlib

open Subgroup

variable {G : Type u} [Group G]

theorem infinite_zpowers_of_orderOf_eq_zero {g : G} (h : orderOf g = 0) : Set.Infinite (zpowers g : Set G) := by
  intro hfin
  have hfin' : IsOfFinOrder g := by rwa [finite_zpowers] at hfin
  have hpos : 0 < orderOf g := orderOf_pos_iff.mpr hfin'
  linarith