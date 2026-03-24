import Mathlib

open BigOperators Finset

/-- A Walrasian (competitive) equilibrium for an infinite-horizon production economy.
    Given a production set Y, endowment sequence ω, discount factor δ, and utility function u,
    a Walrasian equilibrium consists of a production path y* and price sequence p satisfying
    feasibility, myopic profit maximization, and utility maximization. -/
structure WalrasianEquilibrium
    (Y : Set (ℝ × ℝ))
    (ω : ℕ → ℝ)
    (δ : ℝ)
    (u : ℝ → ℝ) where
  /-- Production path: y_star t = (y_b t, y_a t) ∈ Y -/
  y_star : ℕ → ℝ × ℝ
  /-- Price sequence -/
  p : ℕ → ℝ
  /-- Production path lies in Y -/
  prod_in_Y : ∀ t, y_star t ∈ Y
  /-- Feasibility: consumption c_t = y_{a,t-1} + y_{b,t} + ω_t ≥ 0.
      At t=0 we use only y_{b,0} + ω_0 (no previous period output). -/
  feasibility : ∀ t, (if t = 0 then (y_star 0).1 + ω 0
                       else (y_star (t - 1)).2 + (y_star t).1 + ω t) ≥ 0
  /-- Myopic profit maximization: for every t and every (y_b, y_a) ∈ Y,
      p_t · y*_{b,t} + p_{t+1} · y*_{a,t} ≥ p_t · y_b + p_{t+1} · y_a -/
  profit_max : ∀ t, ∀ y ∈ Y,
    p t * (y_star t).1 + p (t + 1) * (y_star t).2 ≥ p t * y.1 + p (t + 1) * y.2
  /-- Optimal consumption sequence derived from the equilibrium -/
  consumption : ℕ → ℝ
  /-- Consumption matches the feasibility expression -/
  consumption_def : ∀ t, consumption t =
    if t = 0 then (y_star 0).1 + ω 0
    else (y_star (t - 1)).2 + (y_star t).1 + ω t
  /-- Consumption is nonnegative -/
  consumption_nonneg : ∀ t, consumption t ≥ 0
  /-- Utility maximization: for any alternative nonneg consumption sequence c
      satisfying the single budget constraint, the equilibrium consumption
      yields at least as high discounted utility (for any finite horizon T). -/
  utility_max : ∀ T : ℕ, ∀ c : ℕ → ℝ,
    (∀ t, c t ≥ 0) →
    (∑ t ∈ range T, p t * c t ≤
     ∑ t ∈ range T, (p t * (y_star t).1 + p (t + 1) * (y_star t).2) +
     ∑ t ∈ range T, p t * ω t) →
    ∑ t ∈ range T, δ ^ t * u (c t) ≤ ∑ t ∈ range T, δ ^ t * u (consumption t)