import Mathlib.Data.Real.Basic

theorem neg_abs_le_self_and_self_le_abs (x : ℝ) : -|x| ≤ x ∧ x ≤ |x| :=
  abs_le.1 (le_refl _)