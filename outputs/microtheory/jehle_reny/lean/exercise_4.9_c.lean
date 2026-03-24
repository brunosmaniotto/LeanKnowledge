import Mathlib
open Topology

theorem Exercise_4_9_c
    (a c : ℝ)
    (hac : a > c)
    (hc : c ≥ 0) :
    (a - c) ^ 2 / 8 > (a - c) ^ 2 / 16 := by
  have h : a - c > 0 := by linarith
  have h2 : (a - c) ^ 2 > 0 := by nlinarith
  linarith