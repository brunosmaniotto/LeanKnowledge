import Mathlib

open ArithmeticFunction

theorem Sigma_Function_Odd_iff_Argument_is_Square_or_Twice_Square (n : ℕ) :
    Odd (sigma n) ↔ (∃ k, n = k ^ 2) ∨ (∃ k, n = 2 * k ^ 2) := by
  sorry