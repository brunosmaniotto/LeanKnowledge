import Mathlib

theorem Claim_Vickrey3_p30_o (v : ℝ) {N : ℕ} (hN : N ≠ 0) :
    v - (((N : ℝ) - 1) / (N : ℝ) * v) = v / (N : ℝ) := by
  field_simp
  ring