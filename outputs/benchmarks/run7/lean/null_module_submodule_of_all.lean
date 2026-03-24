import Mathlib

variable (R G : Type _) [Ring R] [AddCommGroup G] [Module R G]

def zeroSubmodule : Submodule R G :=
  { carrier := {0}
    zero_mem' := by simp
    add_mem' := by
      intro a b ha hb
      simp only [Set.mem_singleton_iff] at ha hb
      simp [ha, hb]
    smul_mem' := by
      intro r a ha
      simp only [Set.mem_singleton_iff] at ha
      simp [ha] }