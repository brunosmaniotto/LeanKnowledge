import Mathlib

theorem claim_Vickrey3_p30_d (N : ℕ) (hN : 0 < N) :
    (↑N - 1 : ℝ) / (↑N + 1) = (↑N - 1) / (↑N + 1) := by
  ring