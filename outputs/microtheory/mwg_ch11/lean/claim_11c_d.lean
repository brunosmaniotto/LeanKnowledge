import Mathlib

theorem per_unit_subsidy_restores_efficiency
    (φ₁' φ₂' c' : ℝ → ℝ)
    (q_star q_hat p_hat : ℝ)
    (samuelson : φ₁' q_star + φ₂' q_star = c' q_star)
    (foc1 : φ₁' q_hat + φ₂' q_star = p_hat)
    (foc2 : φ₂' q_hat + φ₁' q_star = p_hat)
    (market_clearing : p_hat = c' q_hat)
    (constant_mc : c' q_star = c' q_hat)
    (unique : φ₁' q_hat + φ₂' q_hat = c' q_hat → q_hat = q_star)
    : q_hat = q_star := by
  apply unique
  linarith