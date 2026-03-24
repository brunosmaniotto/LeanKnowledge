import Mathlib

theorem int_units (x : ℤ) (h : IsUnit x) : x = 1 ∨ x = -1 :=
  Int.isUnit_iff.mp h