import Mathlib

open Set
open Subgroup

theorem subgroup_inv_eq_self (G : Type*) [Group G] (H : Subgroup G) : (H : Set G)⁻¹ = H := by
  ext x
  simp [mem_inv, H.inv_mem_iff]