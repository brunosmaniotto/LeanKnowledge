import Mathlib

open Finset BigOperators
open Topology
open BigOperators

/-- A private ownership economy with I consumers, J firms, and L commodities. -/
structure PrivateOwnershipEconomy (I J : Type*) [Fintype I] [Fintype J] (L : ℕ) where
  /-- Consumption set for each consumer -/
  consumptionSet : I → Set (Fin L → ℝ)
  /-- Production set for each firm -/
  productionSet : J → Set (Fin L → ℝ)
  /-- Preference: consumer i weakly prefers x to y -/
  pref : I → (Fin L → ℝ) → (Fin L → ℝ) → Prop
  /-- Initial endowment for each consumer -/
  endowment : I → Fin L → ℝ
  /-- Ownership share: θ_{ij} is consumer i's share of firm j -/
  ownershipShare : I → J → ℝ

/-- A Walrasian (competitive) equilibrium for a private ownership economy.
    Definition 16.B.3: an allocation (x*, y*) and price vector p such that
    (i) firms maximize profits, (ii) consumers maximize preferences subject to
    budget constraints, and (iii) markets clear. -/
structure WalrasianEquilibrium {I J : Type*} [Fintype I] [Fintype J] {L : ℕ}
    (E : PrivateOwnershipEconomy I J L) where
  /-- Consumption allocation for each consumer -/
  x : I → Fin L → ℝ
  /-- Production plan for each firm -/
  y : J → Fin L → ℝ
  /-- Price vector -/
  p : Fin L → ℝ
  /-- Each consumer's allocation is in their consumption set -/
  x_mem : ∀ i, x i ∈ E.consumptionSet i
  /-- Each firm's production plan is in their production set -/
  y_mem : ∀ j, y j ∈ E.productionSet j
  /-- (i) Profit maximization: for every firm j, y_j* maximizes p · y_j over Y_j -/
  profitMax : ∀ j, ∀ yj ∈ E.productionSet j,
    ∑ l, p l * (y j l) ≥ ∑ l, p l * (yj l)
  /-- (ii) Consumer optimality: x_i* is maximal for ≿_i in the budget set -/
  consumerOpt : ∀ i, ∀ xi ∈ E.consumptionSet i,
    ∑ l, p l * (xi l) ≤
      ∑ l, p l * (E.endowment i l) + ∑ j, E.ownershipShare i j * ∑ l, p l * (y j l) →
    E.pref i (x i) xi
  /-- (iii) Market clearing: Σ_i x_i* = Σ_i ω_i + Σ_j y_j* -/
  marketClearing : ∀ l, ∑ i, x i l = ∑ i, E.endowment i l + ∑ j, y j l