import Mathlib

variable {G : Type*} [CommGroup G] (H : Subgroup G)

theorem subgroup_normal_of_comm : Subgroup.Normal H := by
  refine { conj_mem := fun h hH g => ?_ }
  rw [mul_comm g h, mul_inv_cancel_right]
  exact hH