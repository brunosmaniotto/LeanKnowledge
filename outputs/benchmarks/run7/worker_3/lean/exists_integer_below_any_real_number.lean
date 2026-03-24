import Mathlib

theorem exists_int_below (x : ℝ) : ∃ n : ℤ, n < x :=
  exists_int_lt x