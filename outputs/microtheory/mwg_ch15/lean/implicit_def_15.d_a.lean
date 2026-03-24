import Mathlib
open Topology
open BigOperators

/-- Production economy with J firms and L factors. -/
structure ProductionEconomy (L J : ℕ) where
  /-- Production function for firm j, mapping factor inputs to output. -/
  prodFun : Fin J → (Fin L → ℝ) → ℝ
  /-- Total endowment of each factor. -/
  endowment : Fin L → ℝ
  /-- Output prices (fixed). -/
  outputPrice : Fin J → ℝ
  /-- Endowments are strictly positive. -/
  endowment_pos : ∀ ℓ, 0 < endowment ℓ
  /-- Output prices are nonneg. -/
  outputPrice_nonneg : ∀ j, 0 ≤ outputPrice j

/-- Factor demand: firm j's profit-maximizing input choice given output price p_j
    and factor prices w. The set of all z_j ≥ 0 that maximize p_j · f_j(z_j) - w · z_j. -/
noncomputable def factorDemand {L J : ℕ} (E : ProductionEconomy L J)
    (w : Fin L → ℝ) (j : Fin J) : Set (Fin L → ℝ) :=
  {z | (∀ ℓ, 0 ≤ z ℓ) ∧
    ∀ z' : Fin L → ℝ, (∀ ℓ, 0 ≤ z' ℓ) →
      E.outputPrice j * E.prodFun j z' - ∑ ℓ, w ℓ * z' ℓ ≤
      E.outputPrice j * E.prodFun j z  - ∑ ℓ, w ℓ * z ℓ}

/-- Factor market equilibrium: factor prices w* > 0 and allocations z* such that
    each firm's allocation is in its factor demand set and all factor markets clear. -/
structure FactorMarketEquilibrium {L J : ℕ} (E : ProductionEconomy L J) where
  /-- Equilibrium factor prices. -/
  factorPrice : Fin L → ℝ
  /-- Equilibrium factor allocation for each firm. -/
  allocation : Fin J → (Fin L → ℝ)
  /-- Factor prices are strictly positive. -/
  factorPrice_pos : ∀ ℓ, 0 < factorPrice ℓ
  /-- Each firm's allocation is profit-maximizing. -/
  profit_max : ∀ j, allocation j ∈ factorDemand E factorPrice j
  /-- Factor markets clear: total demand equals endowment for each factor. -/
  market_clearing : ∀ ℓ, ∑ j, allocation j ℓ = E.endowment ℓ