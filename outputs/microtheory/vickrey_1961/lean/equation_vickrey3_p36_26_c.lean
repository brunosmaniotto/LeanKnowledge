import Mathlib

open Real

/-
Theorem: (Equation_Vickrey3_p36_26_C)
In order for the maximum bids to be the same, for v1 = 1, x = a - a^2/4.
For y2 = 1, we must have log y2 = 0, which implies C = log(a/(2-a)) + a/(2-a).
-/

lemma equation_vickrey_log_y2 (y2 : ℝ) (hy2 : y2 = 1) : log y2 = 0 := by
  rw [hy2]
  exact log_one