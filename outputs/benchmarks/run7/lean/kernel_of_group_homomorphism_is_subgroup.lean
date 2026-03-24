import Mathlib

def kernel_is_subgroup (G H : Type*) [Group G] [Group H] (φ : G →* H) : Subgroup G :=
  { carrier := {g | φ g = 1}
    one_mem' := by simp
    mul_mem' := by
      intro a b ha hb
      simp only [Set.mem_setOf_eq] at ha hb
      simp [ha, hb, map_mul]
    inv_mem' := by
      intro a ha
      simp only [Set.mem_setOf_eq] at ha
      simp [ha, map_inv] }