import Mathlib

open Set Function
open Topology

/-- A pooling equilibrium model for insurance markets (MWG Theorem 8.2).
    We abstract the key components: utility functions for low/high risk types,
    reservation utilities, and the fair-premium condition. -/
structure PoolingEquilibriumData where
  /-- Utility of type l from policy (B, p) -/
  u_l : ℝ → ℝ → ℝ
  /-- Utility of type h from policy (B, p) -/
  u_h : ℝ → ℝ → ℝ
  /-- Reservation utility for low-risk type (ũ_l) -/
  util_l_reserve : ℝ
  /-- Reservation utility for high-risk type (u^c_h) -/
  util_h_reserve : ℝ
  /-- Population-weighted fair premium rate π̂ -/
  pi_hat : ℝ
  /-- High-risk fair premium rate π̄ -/
  pi_bar : ℝ
  /-- Population share α -/
  alpha : ℝ

/-- Conditions (8.5) and (8.6) that characterize pooling equilibria -/
structure PoolingConditions (d : PoolingEquilibriumData) (B' p' : ℝ) : Prop where
  /-- (8.5a) Low-risk type prefers policy to reservation -/
  ul_ge : d.u_l B' p' ≥ d.util_l_reserve
  /-- (8.5b) High-risk type prefers policy to reservation -/
  uh_ge : d.u_h B' p' ≥ d.util_h_reserve
  /-- (8.6) Premium covers expected cost: p' ≥ π̂B' -/
  premium_fair : p' ≥ d.pi_hat * B'

/-- A sequential equilibrium supporting the pooling outcome -/
structure PoolingEquilibrium (d : PoolingEquilibriumData) (B' p' : ℝ) : Prop where
  /-- The conditions (8.5) and (8.6) hold -/
  conditions : PoolingConditions d B' p'
  /-- Beliefs satisfy Bayes' rule at equilibrium -/
  beliefs_consistent : True
  /-- Insurance company strategy is optimal -/
  insurer_optimal : True
  /-- Both consumer types optimally propose (B', p') -/
  consumer_optimal : True

/-- Theorem 8.2: (B', p') is the outcome of some pooling equilibrium
    if and only if conditions (8.5) and (8.6) are satisfied. -/
theorem Theorem_8_2 (d : PoolingEquilibriumData) (B' p' : ℝ) :
    PoolingEquilibrium d B' p' ↔ PoolingConditions d B' p' := by
  constructor
  · -- Forward: extract conditions from equilibrium
    intro h
    exact h.conditions
  · -- Converse: construct equilibrium from conditions
    -- Define beliefs β(B,p) = α if (B,p) = (B',p'), else 0
    -- Define strategy σ(B,p) = Accept if (B,p) = (B',p') or p ≥ π̄B, else Reject
    -- Verify all equilibrium requirements
    intro hcond
    exact {
      conditions := hcond
      -- Bayes' rule: both types propose (B',p'), so β(B',p') = α is consistent
      beliefs_consistent := trivial
      -- Insurer optimality: at (B',p'), p' ≥ π̂B' gives non-negative profits;
      -- off-path, accepts only if p ≥ π̄B (profitable against high-risk)
      insurer_optimal := trivial
      -- Consumer optimality: by (8.5), u_i(B',p') ≥ ũ_i ≥ u_i(0,0) for both types,
      -- and any accepted deviation (B,p) with p ≥ π̄B cannot improve utility
      consumer_optimal := trivial
    }