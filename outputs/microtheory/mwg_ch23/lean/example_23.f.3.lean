import Mathlib
open Topology

/-- Bilateral trade setting with adverse selection: seller has type θ_L (prob 0.8) or θ_H (prob 0.2).
    y is probability of trade, t is transfer payment. -/
structure BilateralTradeSCF where
  y_L : ℝ  -- probability of trade when seller is low type
  y_H : ℝ  -- probability of trade when seller is high type
  t_L : ℝ  -- transfer to seller when low type
  t_H : ℝ  -- transfer to seller when high type
  y_L_range : 0 ≤ y_L ∧ y_L ≤ 1
  y_H_range : 0 ≤ y_H ∧ y_H ≤ 1

/-- Seller's utility: type θ_L has value 20, type θ_H has value 40.
    Seller utility = t - θ * y (transfer minus opportunity cost of giving up good) -/
def sellerUtility_L (scf : BilateralTradeSCF) : ℝ := scf.t_L - 20 * scf.y_L