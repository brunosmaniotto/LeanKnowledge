import Mathlib

open Subgroup
open QuotientGroup

variable {G : Type*} [Group G] {N : Subgroup G} [N.Normal]
variable {A B : Subgroup G}

theorem intersection_of_quotient_groups (hNA : N ≤ A) (hNB : N ≤ B) :
    (A ⊓ B).map (mk' N) = (A.map (mk' N)) ⊓ (B.map (mk' N)) := by
  ext x
  constructor
  · intro hx
    rcases mem_map.mp hx with ⟨g, ⟨hgA, hgB⟩, rfl⟩
    exact ⟨mem_map.mpr ⟨g, hgA, rfl⟩, mem_map.mpr ⟨g, hgB, rfl⟩⟩
  · intro hx
    rcases hx with ⟨hx_left, hx_right⟩
    rcases mem_map.mp hx_left with ⟨a, ha, rfl⟩
    rcases mem_map.mp hx_right with ⟨b, hb, h_eq⟩
    have h_eq' : (mk' N) b = (mk' N) a := h_eq
    have h_inv_mul : b⁻¹ * a ∈ N := QuotientGroup.eq.1 h_eq'
    have h_inv_mul_in_B : b⁻¹ * a ∈ B := hNB h_inv_mul
    have ha_in_B : a ∈ B := by
      have : a = b * (b⁻¹ * a) := by group
      rw [this]
      exact mul_mem hb h_inv_mul_in_B
    exact mem_map.mpr ⟨a, ⟨ha, ha_in_B⟩, rfl⟩