import Mathlib

open Real

theorem sum_of_arcsin_and_arccos (x : ℝ) (hx : -1 ≤ x ∧ x ≤ 1) : arcsin x + arccos x = π / 2 := by
  rw [arccos_eq_pi_div_two_sub_arcsin x]
  ring