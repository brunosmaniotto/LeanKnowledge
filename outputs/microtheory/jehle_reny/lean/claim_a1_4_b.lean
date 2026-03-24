import Mathlib
open Topology

theorem claim_A1_4_b {X Y : Type*} (f : X → Y) (y₁ y₂ : Y) (h : y₁ ≠ y₂) :
    f ⁻¹' {y₁} ∩ f ⁻¹' {y₂} = ∅ := by
  ext x
  simp [Set.mem_empty_iff_false, Set.mem_inter_iff, Set.mem_preimage, Set.mem_singleton_iff]
  intro h1
  rw [h1]
  exact h