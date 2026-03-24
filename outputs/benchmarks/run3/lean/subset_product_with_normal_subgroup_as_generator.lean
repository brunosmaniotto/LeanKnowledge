import Mathlib
open Subgroup
open scoped Pointwise

variable {G : Type*} [Group G] (H N : Subgroup G)

theorem subset_product_with_normal_subgroup_as_generator (hN : N.Normal) :
    (↑(N ⊔ H) : Set G) = (N : Set G) * (H : Set G) ∧
    (N : Set G) * (H : Set G) = (H : Set G) * (N : Set G) ∧
    (N.subgroupOf (N ⊔ H)).Normal := by
  haveI := hN
  have h1 : ↑(N ⊔ H) = (N : Set G) * (H : Set G) := Subgroup.normal_mul N H
  have h2 : ↑(H ⊔ N) = (H : Set G) * (N : Set G) := Subgroup.mul_normal H N
  have h3 : (N : Set G) * (H : Set G) = (H : Set G) * (N : Set G) := by
    calc
      (N : Set G) * (H : Set G) = ↑(N ⊔ H) := by rw [h1]
      _ = ↑(H ⊔ N) := by rw [sup_comm]
      _ = (H : Set G) * (N : Set G) := by rw [h2]
  exact ⟨h1, h3, hN.subgroupOf (N ⊔ H)⟩