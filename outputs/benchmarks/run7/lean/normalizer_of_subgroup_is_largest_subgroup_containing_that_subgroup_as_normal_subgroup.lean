import Mathlib

open Subgroup

variable {G : Type*} [Group G] (H : Subgroup G)

theorem normalizer_is_largest_subgroup_with_normal_subgroup :
    H ≤ H.normalizer ∧ (H.subgroupOf H.normalizer).Normal ∧
      ∀ (K : Subgroup G), H ≤ K → (∀ k ∈ K, ∀ h ∈ H, k * h * k⁻¹ ∈ H) → K ≤ H.normalizer := by
  constructor
  · exact H.le_normalizer
  constructor
  · exact H.normal_in_normalizer
  · intro K hHK h_norm
    intro k hk
    rw [mem_normalizer_iff]
    intro h
    constructor
    · intro hh
      exact h_norm k hk h hh
    · intro hh
      have hk_inv : k⁻¹ ∈ K := K.inv_mem hk
      have := h_norm k⁻¹ hk_inv (k * h * k⁻¹) hh
      simp [mul_assoc] at this
      exact this