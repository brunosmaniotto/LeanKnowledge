import Mathlib

theorem Claim_11E_e (b c : ℝ) (h_bc : b > c) : -(b - c) < 0 := by
  linarith [h_bc]