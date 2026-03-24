import Mathlib
set_option linter.unusedVariables false

noncomputable def gc_h (b_hat c_hat h_bar : ℝ) : ℝ :=
  if b_hat ≥ c_hat then h_bar else 0

noncomputable def consumer_payoff (c b_hat c_hat h_bar : ℝ) : ℝ :=
  (b_hat - c) * gc_h b_hat c_hat h_bar

theorem Claim_11E_d (c b_hat c_hat h_bar : ℝ) (hh : 0 ≤ h_bar) :
    consumer_payoff c b_hat c h_bar ≥ consumer_payoff c b_hat c_hat h_bar := by
  unfold consumer_payoff gc_h
  by_cases h1 : b_hat ≥ c
  · rw [if_pos h1]
    by_cases h2 : b_hat ≥ c_hat
    · rw [if_pos h2]
    · rw [if_neg h2, mul_zero]
      exact mul_nonneg (by linarith) hh
  · rw [if_neg h1, mul_zero]
    by_cases h2 : b_hat ≥ c_hat
    · rw [if_pos h2]
      have key : 0 ≤ (c - b_hat) * h_bar := mul_nonneg (by linarith) hh
      linarith [show (b_hat - c) * h_bar + (c - b_hat) * h_bar = (0:ℝ) from by ring]
    · rw [if_neg h2, mul_zero]