import Mathlib

variable {R : Type} [Ring R]

def Ideal.toNonUnitalSubring (J : Ideal R) : NonUnitalSubring R :=
  { J.toAddSubgroup with
    mul_mem' := fun ha hb => J.mul_mem_left _ hb }