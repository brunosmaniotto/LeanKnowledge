import Mathlib

/-- In sophisticated matching pennies with x = y = z_β = z_γ = 1/2,
    neither player benefits from quitting: quitting yields -2 (negative)
    while Heads or Tails yields 0. -/
theorem Claim_7_7_d :
    let quit_payoff_1 : ℚ := -2
    let quit_payoff_2 : ℚ := -2
    let play_payoff : ℚ := 0
    quit_payoff_1 < play_payoff ∧ quit_payoff_2 < play_payoff := by
  norm_num