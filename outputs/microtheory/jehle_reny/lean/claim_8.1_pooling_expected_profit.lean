import Mathlib

theorem Claim_8_1_pooling_expected_profit
    (α π π_bar p B : ℝ) :
    α * (p - π * B) + (1 - α) * (p - π_bar * B) =
      p - (α * π + (1 - α) * π_bar) * B := by
  ring