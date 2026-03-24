import Mathlib

open Finset BigOperators
open BigOperators

/-- A private ownership economy with I consumers, J firms, and L goods. -/
structure PrivateOwnershipEconomy (I J L : Type*) [Fintype I] [Fintype J] [Fintype L] where
  /-- Consumption set for each consumer -/
  X : I → Set (L → ℝ)
  /-- Preference relation for each consumer (≿_i) -/
  pref : I → (L → ℝ) → (L → ℝ) → Prop
  /-- Production set for each firm -/
  Y : J → Set (L → ℝ)
  /-- Initial endowment for each consumer -/
  ω : I → (L → ℝ)
  /-- Ownership share of consumer i in firm j -/
  θ : I → J → ℝ

/-- A Walrasian (competitive) equilibrium for a private ownership economy.
    Definition 17.B.1 (repeats 16.B.3): an allocation (x*, y*) and price vector p
    such that firms maximize profits, consumers maximize preferences in their
    budget sets, and markets clear. -/
structure WalrasianEquilibrium {I J L : Type*} [Fintype I] [Fintype J] [Fintype L]
    (E : PrivateOwnershipEconomy I J L) where
  /-- Equilibrium consumption bundle for each consumer -/
  x : I → (L → ℝ)
  /-- Equilibrium production plan for each firm -/
  y : J → (L → ℝ)
  /-- Price vector -/
  p : L → ℝ
  /-- Each x*_i is in the consumption set -/
  x_mem : ∀ i, x i ∈ E.X i
  /-- Each y*_j is in the production set -/
  y_mem : ∀ j, y j ∈ E.Y j
  /-- (i) Profit maximization: for every firm j, y*_j maximizes p · y over Y_j -/
  profit_max : ∀ j, ∀ yj ∈ E.Y j,
    ∑ l : L, p l * yj l ≤ ∑ l : L, p l * (y j) l
  /-- (ii) Utility maximization: x*_i is maximal for ≿_i in the budget set -/
  utility_max : ∀ i, ∀ xi ∈ E.X i,
    ∑ l : L, p l * xi l ≤ ∑ l : L, p l * (E.ω i) l + ∑ j : J, E.θ i j * ∑ l : L, p l * (y j) l →
    ¬ E.pref i xi (x i)
  /-- (iii) Market clearing: total consumption = total endowment + total production -/
  market_clearing : ∀ l : L,
    ∑ i : I, (x i) l = ∑ i : I, (E.ω i) l + ∑ j : J, (y j) l