import Mathlib

theorem ZMod.mul_comm_mod (m : ℕ) (x y : ZMod m) : x * y = y * x :=
  mul_comm x y