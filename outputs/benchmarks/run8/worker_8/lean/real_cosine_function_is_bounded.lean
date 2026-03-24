import Mathlib

open Real

theorem cos_abs_le_one (x : ℝ) : |cos x| ≤ 1 :=
  abs_cos_le_one x