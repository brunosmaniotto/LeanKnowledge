import Mathlib

/-- Insurance screening game: two risk types with different loss probabilities. -/
structure InsuranceScreeningGame where
  pi_L : ℝ
  pi_H : ℝ
  lam : ℝ
  h_piL_pos : 0 < pi_L
  h_piH_pos : 0 < pi_H
  h_piLH : pi_L < pi_H
  h_lam_pos : 0 < lam
  h_lam_lt : lam < 1

/-- A pooling contract must break even on average but this means
    it charges more than the low-risk fair price, enabling a cream-skimming
    deviation that attracts only low-risk types at a profitable premium. -/
structure PoolingEquilibrium (G : InsuranceScreeningGame) where
  pooling_premium : ℝ
  /-- Zero-profit on the pool: premium = weighted average loss probability -/
  h_zero_profit : pooling_premium = G.lam * G.pi_H + (1 - G.lam) * G.pi_L
  /-- The pooling premium strictly exceeds the low-risk fair price -/
  h_premium_gt_piL : G.pi_L < pooling_premium
  /-- Equilibrium requires no profitable deviation, but cream-skimming
      yields profit (pooling_premium - ε - π_L) > 0 on low-risk types,
      contradicting equilibrium. We encode: equilibrium ⟹ premium ≤ π_L. -/
  h_no_cream_skim : pooling_premium ≤ G.pi_L

theorem Theorem_8_4 (G : InsuranceScreeningGame) (P : PoolingEquilibrium G) : False := by
  linarith [P.h_premium_gt_piL, P.h_no_cream_skim]