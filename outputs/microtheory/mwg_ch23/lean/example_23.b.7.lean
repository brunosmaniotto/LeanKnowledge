import Mathlib

noncomputable def auction_payoff (report true_type : ℝ) : ℝ :=
  (true_type - report / 2) * report

theorem Example_23_B_7 (t r : ℝ) :
    auction_payoff t t ≥ auction_payoff r t := by
  unfold auction_payoff
  nlinarith [sq_nonneg (t - r)]