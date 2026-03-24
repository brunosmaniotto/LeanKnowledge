import Mathlib

open Finset BigOperators
open BigOperators

variable {L : Type*} [Fintype L] [DecidableEq L]

/-- An economy with I consumers and J firms trading L commodities. -/
structure Economy (I J L : Type*) [Fintype I] [Fintype J] [Fintype L] where
  /-- Consumption set for consumer i -/
  consumptionSet : I → Set (L → ℝ)
  /-- Preference: `pref i x y` means consumer i weakly prefers x to y -/
  pref : I → (L → ℝ) → (L → ℝ) → Prop
  /-- Production set for firm j -/
  productionSet : J → Set (L → ℝ)
  /-- Aggregate endowment -/
  endowment : L → ℝ

/-- A price equilibrium with transfers for an economy.
    Given an allocation (x*, y*) and price vector p, this packages the
    wealth assignment and the three equilibrium conditions. -/
structure PriceEquilibriumWithTransfers
    {I J L : Type*} [Fintype I] [Fintype J] [Fintype L] [DecidableEq I] [DecidableEq J] [DecidableEq L]
    (E : Economy I J L)
    (p : L → ℝ)
    (xStar : I → L → ℝ)
    (yStar : J → L → ℝ) where
  /-- Wealth assignment for each consumer -/
  wealth : I → ℝ
  /-- Wealth levels sum to the value of endowment plus total profits -/
  wealth_sum :
    ∑ i, wealth i = ∑ l, p l * E.endowment l + ∑ j, ∑ l, p l * yStar j l
  /-- Each x_i* is in the consumption set -/
  xStar_mem : ∀ i, xStar i ∈ E.consumptionSet i
  /-- Each y_j* is in the production set -/
  yStar_mem : ∀ j, yStar j ∈ E.productionSet j
  /-- (i) Profit maximization: y_j* maximizes p · y over Y_j -/
  profit_max : ∀ j, ∀ yj ∈ E.productionSet j,
    ∑ l, p l * yj l ≤ ∑ l, p l * yStar j l
  /-- (ii) Consumer optimality: x_i* is maximal for ≿_i in the budget set -/
  consumer_optimal : ∀ i, ∀ xi ∈ E.consumptionSet i,
    ∑ l, p l * xi l ≤ wealth i → E.pref i xi (xStar i) → E.pref i (xStar i) xi
  /-- (ii) Budget feasibility: x_i* satisfies the budget constraint -/
  budget_feasible : ∀ i, ∑ l, p l * (xStar i) l ≤ wealth i
  /-- (iii) Market clearing: total consumption = endowment + total production -/
  market_clearing : ∀ l,
    ∑ i, xStar i l = E.endowment l + ∑ j, yStar j l