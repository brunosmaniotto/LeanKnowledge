import Mathlib

theorem consecutive_integers_coprime (h : ℤ) : Int.gcd (h + 1) h = 1 := by
  rw [add_comm h 1, Int.gcd_add_self_left, Int.gcd_one_left]