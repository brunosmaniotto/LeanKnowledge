import Mathlib
open Topology

theorem Claim_Vickrey3_p32_b (a b : ℝ) (h_ne : b - a ≠ 0) (h : 1 / (b - a) = 1) : b - a = 1 := by
  have := div_eq_iff h_ne |>.mp h
  linarith