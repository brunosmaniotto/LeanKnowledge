import Mathlib
open Topology

/-- An insurance policy specified by benefit B and premium p. -/
structure InsurancePolicy where
  B : ℝ
  p : ℝ

/-- Definition 8.1: A pure strategy sequential equilibrium of the insurance signalling game.
    An assessment (ψL, ψH, σ, β) satisfying sequential rationality and Bayesian consistency. -/
structure IsSequentialEquilibrium
    (uL uH : InsurancePolicy → Bool → ℝ)
    (expProfit : InsurancePolicy → ℝ → Bool → ℝ)
    (α : ℝ)
    (ψL ψH : InsurancePolicy)
    (σ : InsurancePolicy → Bool)
    (β : InsurancePolicy → ℝ) : Prop where
  -- (1a) Low-risk type optimally proposes ψL given insurer strategy σ
  low_risk_optimal : ∀ ψ : InsurancePolicy, uL ψL (σ ψL) ≥ uL ψ (σ ψ)
  -- (1b) High-risk type optimally proposes ψH given insurer strategy σ
  high_risk_optimal : ∀ ψ : InsurancePolicy, uH ψH (σ ψH) ≥ uH ψ (σ ψ)
  -- (2a) Beliefs are valid probabilities
  beliefs_valid : ∀ ψ : InsurancePolicy, 0 ≤ β ψ ∧ β ψ ≤ 1
  -- (2b) Separating case: if proposals differ, beliefs are degenerate
  beliefs_separating : ψL ≠ ψH → β ψL = 1 ∧ β ψH = 0
  -- (2c) Pooling case: if proposals coincide, beliefs equal the prior
  beliefs_pooling : ψL = ψH → β ψL = α
  -- (3) Insurer's reaction maximises expected profit given beliefs
  insurer_optimal : ∀ ψ : InsurancePolicy, expProfit ψ (β ψ) (σ ψ) ≥ expProfit ψ (β ψ) (!(σ ψ))