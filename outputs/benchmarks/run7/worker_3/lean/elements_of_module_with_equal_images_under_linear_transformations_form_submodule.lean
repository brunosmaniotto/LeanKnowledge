import Mathlib

variable (R : Type*) [Ring R] (G H : Type*) [AddCommGroup G] [Module R G] [AddCommGroup H] [Module R H]

def ElementsOfModuleWithEqualImagesUnderLinearTransformationsFormSubmodule (φ ψ : G →ₗ[R] H) : Submodule R G :=
  { carrier := {x | φ x = ψ x}
    zero_mem' := by
      simp
    add_mem' := by
      intro x y hx hy
      simp only [Set.mem_setOf_eq] at hx hy ⊢
      rw [LinearMap.map_add, LinearMap.map_add, hx, hy]
    smul_mem' := by
      intro c x hx
      simp only [Set.mem_setOf_eq] at hx ⊢
      rw [LinearMap.map_smul, LinearMap.map_smul, hx] }