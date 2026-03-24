import Mathlib
open Topology

/-- OLG learning dynamics with fiat money and adaptive expectations.
    The extrapolation rule sets expected future price equal to the most recently
    observed price: pᵉ_{t+1} = p_{t-1}. -/
structure OLGLearningDynamics where
  /-- Fiat money supply M > 0 -/
  M : ℝ
  M_pos : 0 < M
  /-- Excess demand of the young (born-period demand) as a function of
      current price and expected future price -/
  z_b : ℝ → ℝ → ℝ
  /-- Excess demand of the old (sell-period demand) as a function of
      current price and previous price -/
  z_a : ℝ → ℝ → ℝ
  /-- Temporary equilibrium condition with adaptive expectations:
      z_b(p_t, p_{t-1}) + M / p_t = 0 for all positive prices -/
  temp_eq : ∀ (p_t p_prev : ℝ), 0 < p_t → 0 < p_prev →
    z_b p_t p_prev + M / p_t = 0
  /-- Equivalent formulation via old's excess demand:
      z_a(p_t, p_{t-1}) = M / p_{t-1} -/
  old_demand_eq : ∀ (p_t p_prev : ℝ), 0 < p_t → 0 < p_prev →
    z_a p_t p_prev = M / p_prev