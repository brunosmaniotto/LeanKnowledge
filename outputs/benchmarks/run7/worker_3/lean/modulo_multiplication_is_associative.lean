import Mathlib

theorem ZMod.mul_assoc_mod (m : ℕ) (x y z : ZMod m) : (x * y) * z = x * (y * z) :=
  mul_assoc x y z