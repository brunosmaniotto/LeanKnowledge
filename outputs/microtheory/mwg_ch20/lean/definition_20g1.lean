import Mathlib

open BigOperators Finset
open Topology

/-- A Walrasian (competitive) equilibrium for a multi-consumer production economy
    with bounded production paths and infinite time horizon. -/
structure WalrasianEquilibrium
    (I : ℕ)                          -- number of consumers
    (Y : Set (ℝ × ℝ))               -- production set (input today, output tomorrow)
    (u : Fin I → ℝ → ℝ)             -- utility function for each consumer
    (δ : ℝ)                          -- discount factor
    (ω : Fin I → ℕ → ℝ)             -- endowment stream for each consumer
    (θ : Fin I → ℕ → ℝ)             -- profit share of consumer i in period t
    (T : ℕ)                          -- time horizon (finite approximation)
    where
  /-- Production path: y_t ∈ Y for each period -/
  y₀ : ℕ → ℝ    -- input component of production in each period
  y₁ : ℕ → ℝ    -- output component of production in each period
  /-- Price sequence -/
  p : ℕ → ℝ
  /-- Consumption stream for each consumer -/
  c : Fin I → ℕ → ℝ
  /-- Production is feasible: (y₀_t, y₁_t) ∈ Y for all t -/
  prod_feasible : ∀ t, (y₀ t, y₁ t) ∈ Y
  /-- Prices are nonnegative -/
  price_nonneg : ∀ t, 0 ≤ p t
  /-- Consumption is nonnegative -/
  cons_nonneg : ∀ i t, 0 ≤ c i t
  /-- (i) Market clearing: total consumption = production output + input + endowments -/
  market_clearing : ∀ t,
    ∑ i : Fin I, c i t = y₀ t + y₁ t + ∑ i : Fin I, ω i t
  /-- (ii) Profit maximization: the production plan maximizes profit at given prices -/
  profit_max : ∀ t, ∀ z₀ z₁ : ℝ, (z₀, z₁) ∈ Y →
    p t * z₀ + p (t + 1) * z₁ ≤ p t * y₀ t + p (t + 1) * y₁ t
  /-- (iii) Utility maximization: each consumer's stream maximizes discounted utility
      subject to the budget constraint -/
  budget_feasible : ∀ i,
    ∑ t ∈ range T, p t * c i t ≤
      ∑ t ∈ range T, θ i t * (p t * y₀ t + p (t + 1) * y₁ t) +
      ∑ t ∈ range T, p t * ω i t
  utility_optimal : ∀ i, ∀ c' : ℕ → ℝ,
    (∀ t, 0 ≤ c' t) →
    (∑ t ∈ range T, p t * c' t ≤
      ∑ t ∈ range T, θ i t * (p t * y₀ t + p (t + 1) * y₁ t) +
      ∑ t ∈ range T, p t * ω i t) →
    ∑ t ∈ range T, δ ^ t * u i (c' t) ≤
      ∑ t ∈ range T, δ ^ t * u i (c i t)