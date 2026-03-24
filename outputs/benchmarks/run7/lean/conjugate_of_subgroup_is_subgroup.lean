import Mathlib

variable {G : Type _} [Group G]

def conjugateSubgroup (H : Subgroup G) (a : G) : Subgroup G where
  carrier := {x | a⁻¹ * x * a ∈ H}
  one_mem' := by
    simp [H.one_mem]
  mul_mem' {x y} hx hy := by
    simp only [Set.mem_setOf_eq] at hx hy ⊢
    have h1 : a⁻¹ * (x * y) * a = (a⁻¹ * x * a) * (a⁻¹ * y * a) := by
      group
    rw [h1]
    exact H.mul_mem hx hy
  inv_mem' {x} hx := by
    simp only [Set.mem_setOf_eq] at hx ⊢
    have h1 : a⁻¹ * x⁻¹ * a = (a⁻¹ * x * a)⁻¹ := by
      group
    rw [h1]
    exact H.inv_mem hx