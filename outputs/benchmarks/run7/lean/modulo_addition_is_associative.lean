import Mathlib

/-- Addition in integers modulo m is associative. -/
theorem ZMod.add_assoc_mod (m : ℕ) (x y z : ZMod m) : (x + y) + z = x + (y + z) :=
  add_assoc x y z