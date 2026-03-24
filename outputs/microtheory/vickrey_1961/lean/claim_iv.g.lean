import Mathlib

open Real

theorem claim_IV_G (N : ℕ) (hN : 3 ≤ N) (v : ℝ) :
    (v * (↑(N - 2) / ↑(N - 1))) = (↑(N - 2) / ↑(N - 1) * v) := by
  -- The core of the theorem is to show that `v * X = X * v`, where
  -- `X` represents the fraction `(N - 2 : ℝ) / (N - 1 : ℝ)`.
  -- This is a direct application of the commutativity of multiplication in real numbers.
  rw [mul_comm v (↑(N - 2) / ↑(N - 1))]