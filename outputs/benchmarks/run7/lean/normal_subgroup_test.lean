import Mathlib

open Subgroup

variable {G : Type*} [Group G] (H : Subgroup G)

theorem normal_iff_conjugate_subset :
    H.Normal ↔ ∀ x : G, ∀ h ∈ H, x * h * x⁻¹ ∈ H := by
  constructor
  · intro hN x h hh
    exact hN.conj_mem h hh x
  · intro h
    refine { conj_mem := fun n hn g => h g n hn }