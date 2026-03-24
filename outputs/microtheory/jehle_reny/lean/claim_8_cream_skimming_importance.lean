import Mathlib

theorem cream_skimming_importance
    (nFirms : ℕ) (h_compete : nFirms > 1)
    (θ_H θ_L : ℝ) (hHL : θ_L < θ_H)
    (pooling_wage : ℝ)
    (lam : ℝ) (hlam0 : 0 < lam) (hlam1 : lam < 1)
    (h_pool_wage : pooling_wage = lam * θ_H + (1 - lam) * θ_L)
    : θ_H > pooling_wage := by
  rw [h_pool_wage]
  nlinarith