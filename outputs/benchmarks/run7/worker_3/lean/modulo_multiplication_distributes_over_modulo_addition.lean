import Mathlib

variable (m : ℕ)

theorem ZMod.left_distrib (x y z : ZMod m) : x * (y + z) = x * y + x * z :=
  mul_add x y z