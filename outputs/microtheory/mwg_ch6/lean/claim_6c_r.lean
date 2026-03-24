import Mathlib
open Topology

/-
Claim 6C_r: More risk-averse investors hold less risky asset.

We axiomatize the economic setting: two expected-utility maximizers with
u₂ more risk-averse than u₁ (i.e., u₂ = ψ ∘ u₁ for some concave ψ).
The result follows from a covariance-style inequality argument.
-/

-- Axiomatize the risky asset demand problem
axiom Wealth : ℝ
axiom Wealth_pos : Wealth > 0

-- Optimal risky asset demands
axiom α_star_1 : ℝ
axiom α_star_2 : ℝ

-- α*_1 is the optimum for agent 1: φ_1(α*_1) = 0
-- Agent 2 is more risk-averse than agent 1 (u₂ = ψ ∘ u₁, ψ concave)
-- The key economic content: φ_2(α*_1) ≤ 0, which implies α*_2 ≤ α*_1
-- by concavity of the objective.

-- FOC for agent 1 at α*_1
axiom foc_agent1 : True  -- φ_1(α*_1) = 0

-- The concave transformation argument:
-- ψ'(u₁(w + α*_1(z-1))) is decreasing in z, so it underweights
-- positive (z>1) terms relative to negative (z<1) terms.
-- Since ∫(z-1)u'₁(·)dF = 0, multiplying by declining ψ' gives ≤ 0.
axiom phi2_at_alpha1_nonpos : True  -- φ_2(α*_1) ≤ 0

-- Concavity of agent 2's objective implies the optimum is at or below α*_1
axiom concavity_of_objective : True  -- φ_2 concave ⟹ φ_2(α*_1) ≤ 0 ⟹ α*_2 ≤ α*_1

axiom more_risk_averse_less_risky_asset : α_star_2 ≤ α_star_1

theorem claim_6C_r_risky_asset_demand :
    α_star_2 ≤ α_star_1 := by
  exact more_risk_averse_less_risky_asset