import Mathlib

open MeasureTheory intervalIntegral

theorem Claim_Vickrey3_p30_j (N : ℕ) :
    ∫ x in (0 : ℝ)..1, x ^ N = 1 / (↑N + 1 : ℝ) := by
  rw [integral_pow]
  simp only [one_pow, zero_pow (Nat.succ_ne_zero N), sub_zero]