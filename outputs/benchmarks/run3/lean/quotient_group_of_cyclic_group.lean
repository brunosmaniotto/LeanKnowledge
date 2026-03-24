import Mathlib

open Subgroup
open Topology

theorem quotient_group_of_cyclic_group_is_cyclic (G : Type*) [Group G] (g : G) (hgen : ∀ x, x ∈ zpowers g)
    (H : Subgroup G) [H.Normal] : ∀ x : G ⧸ H, ∃ n : ℤ, x = (QuotientGroup.mk g : G ⧸ H) ^ n := by
  intro x
  obtain ⟨a, rfl⟩ := QuotientGroup.mk_surjective x
  obtain ⟨n, rfl⟩ := hgen a
  use n
  rw [← QuotientGroup.mk_zpow]