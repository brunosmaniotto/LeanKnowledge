import Mathlib
open Topology
open Finset

/-- A production plan for period t maps inputs to outputs. -/
structure ProductionPlan (n : ℕ) where
  input : Fin n → ℝ
  output : Fin n → ℝ

/-- Prices are Malinvaud prices for a production path if they sustain the path
    as myopically profit-maximizing: at each period t, the production plan y_t
    maximizes profit p_{t+1} · output - p_t · input over all feasible plans. -/
structure MalinvaudPrices (n : ℕ) (T : ℕ) where
  /-- The price sequence p_0, ..., p_T -/
  prices : Fin (T + 1) → Fin n → ℝ
  /-- The production path y_0, ..., y_{T-1} being sustained -/
  path : Fin T → ProductionPlan n
  /-- The set of feasible production plans at each period -/
  feasible : Fin T → Set (ProductionPlan n)
  /-- Each element of the path is feasible -/
  path_feasible : ∀ t, path t ∈ feasible t
  /-- Myopic profit maximization: at each period t, the production plan y_t
      maximizes p_{t+1} · (output) - p_t · (input) over all feasible plans -/
  profit_maximizing : ∀ t, ∀ y ∈ feasible t,
    Finset.sum Finset.univ (fun i => prices t.castSucc i * (path t).input i) +
    Finset.sum Finset.univ (fun i => prices t.succ i * y.output i) ≤
    Finset.sum Finset.univ (fun i => prices t.castSucc i * (path t).input i) +
    Finset.sum Finset.univ (fun i => prices t.succ i * (path t).output i)