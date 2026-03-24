import Mathlib
open Topology

theorem claim_A1_4_1_a {X Y : Type*} (f : X → Y) (y₀ y₁ : Y) (h : y₀ ≠ y₁) :
    f ⁻¹' {y₀} ∩ f ⁻¹' {y₁} = ∅ := by
  ext x
  simp [Set.mem_empty_iff_false, Set.mem_inter_iff, Set.mem_preimage, Set.mem_singleton_iff]
  intro h₀ h₁
  exact h (h₀ ▸ h₁)