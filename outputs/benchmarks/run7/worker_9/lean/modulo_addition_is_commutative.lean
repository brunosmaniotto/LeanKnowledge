import Mathlib

theorem mod_add_comm (x y m : ℤ) : (x + y) % m = (y + x) % m := by
  rw [add_comm x y]