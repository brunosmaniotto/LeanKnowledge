import Mathlib

open Real

theorem cos_add_formula (a b : ℝ) : cos (a + b) = cos a * cos b - sin a * sin b :=
  cos_add a b