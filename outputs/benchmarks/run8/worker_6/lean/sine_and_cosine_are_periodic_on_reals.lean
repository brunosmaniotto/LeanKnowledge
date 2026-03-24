import Mathlib

open Real

theorem cos_periodic (x : ℝ) : cos (x + 2 * π) = cos x :=
  cos_add_two_pi x