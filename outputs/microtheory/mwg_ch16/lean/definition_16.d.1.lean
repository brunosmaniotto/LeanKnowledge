import Mathlib

open BigOperators Finset
open Topology

/-- A price quasiequilibrium with transfers for a private ownership economy.
    Similar to a price equilibrium with transfers (Definition 16.B.4), but with
    the weaker condition that strictly preferred bundles cost *at least* w_i
    (rather than *strictly more* than w_i). -/
structure PriceQuasiequilibriumWithTransfers
    (I : Type*) [Fintype I]
    (J : Type*) [Fintype J]
    (L : ℕ)
    (X : I → Set (Fin L → ℝ))
    (pref : I → (Fin L → ℝ) → (Fin L → ℝ) → Prop)
    (Y : J → Set (Fin L → ℝ))
    (ω : Fin L → ℝ) where
  /-- Consumption allocation -/
  x : I → Fin L → ℝ
  /-- Production allocation -/
  y : J → Fin L → ℝ
  /-- Price vector -/
  p : Fin L → ℝ
  /-- Wealth levels assigned to each consumer -/
  w : I → ℝ
  /-- Price vector is nonzero -/
  p_ne_zero : p ≠ 0
  /-- Each consumption bundle is in the consumption set -/
  x_mem : ∀ i, x i ∈ X i
  /-- Each production plan is in the production set -/
  y_mem : ∀ j, y j ∈ Y j
  /-- Wealth levels sum to the value of endowment plus total profit -/
  wealth_balance : ∑ i, w i = ∑ l, p l * ω l + ∑ j, ∑ l, p l * (y j) l
  /-- (i) Profit maximization: each firm's plan maximizes profit over its production set -/
  profit_max : ∀ j, ∀ yj ∈ Y j, ∑ l, p l * yj l ≤ ∑ l, p l * (y j) l
  /-- (ii) Quasi-equilibrium condition: if x_i is strictly preferred to x*_i,
      then p · x_i ≥ w_i (weakened from strict inequality in equilibrium) -/
  quasi_cost_min : ∀ i, ∀ xi ∈ X i, pref i xi (x i) → ∑ l, p l * xi l ≥ w i
  /-- (iii) Market clearing -/
  market_clear : ∀ l, ∑ i, (x i) l = ω l + ∑ j, (y j) l