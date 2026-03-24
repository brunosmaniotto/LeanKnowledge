import Mathlib

open Finset BigOperators
open Topology
open BigOperators

/-- A Walrasian quasiequilibrium: an allocation and nonzero price vector satisfying
    profit maximization, budget feasibility with quasi-demand, and market clearing. -/
structure WalrasianQuasiequilibrium
    (I : Type*) [Fintype I]
    (J : Type*) [Fintype J]
    (L : Type*) [Fintype L] [DecidableEq L]
    (X : I → Set (L → ℝ))
    (Y : J → Set (L → ℝ))
    (ω : I → (L → ℝ))
    (θ : I → J → ℝ)
    (pref : I → (L → ℝ) → (L → ℝ) → Prop) where
  /-- Consumption allocation -/
  x : I → (L → ℝ)
  /-- Production plan allocation -/
  y : J → (L → ℝ)
  /-- Price vector -/
  p : L → ℝ
  /-- Price vector is nonzero -/
  p_ne_zero : p ≠ 0
  /-- Each consumption is feasible -/
  x_feasible : ∀ i, x i ∈ X i
  /-- Each production plan is feasible -/
  y_feasible : ∀ j, y j ∈ Y j
  /-- (i) Profit maximization: each firm maximizes profit at prices p -/
  profit_max : ∀ j, ∀ yj ∈ Y j,
    ∑ l : L, p l * yj l ≤ ∑ l : L, p l * (y j) l
  /-- (ii') Budget feasibility: each consumer's expenditure does not exceed wealth -/
  budget_feasible : ∀ i,
    ∑ l : L, p l * (x i) l ≤
      ∑ l : L, p l * (ω i) l + ∑ j : J, θ i j * ∑ l : L, p l * (y j) l
  /-- (ii') Quasi-demand: if x_i is strictly preferred to x_i*, then x_i costs at least wealth -/
  quasi_demand : ∀ i, ∀ xi ∈ X i, pref i xi (x i) →
    ∑ l : L, p l * xi l ≥
      ∑ l : L, p l * (ω i) l + ∑ j : J, θ i j * ∑ l : L, p l * (y j) l
  /-- (iii) Market clearing -/
  market_clearing : ∀ l : L,
    ∑ i : I, (x i) l = ∑ i : I, (ω i) l + ∑ j : J, (y j) l