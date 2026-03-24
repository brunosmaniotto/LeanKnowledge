import Mathlib

theorem expected_externality_mechanism_second_BNE
    (θ_L θ_H : ℝ) (prob : ℝ)
    (hH_pos : θ_H > 0) (hL_neg : θ_L < 0) (hsum : θ_L + θ_H > 0)
    (hprob_pos : 0 < prob) (hprob_lt : prob < 1) :
    let transfer_report_H := prob * θ_H + (1 - prob) * θ_L
    let transfer_report_L := prob * θ_H + (1 - prob) * θ_L
    transfer_report_H = transfer_report_L
    ∧ θ_L ≠ θ_H := by
  constructor
  · ring
  · linarith