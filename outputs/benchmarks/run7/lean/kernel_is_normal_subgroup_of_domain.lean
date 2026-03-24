import Mathlib

open MonoidHom

variable {G H : Type*} [Group G] [Group H]

theorem kernel_is_normal (f : G →* H) : Subgroup.Normal (ker f) :=
  { conj_mem := fun n hn g => by
      rw [mem_ker] at hn ⊢
      simp [map_mul, map_inv, hn] }