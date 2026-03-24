import Mathlib

open Finset BigOperators
open Topology
open BigOperators

/-- Consumer i's problem in the two-period sequential trade model (Problem 19.D.1). -/
structure SequentialTradeConsumerProblem (L S : ℕ) where
  /-- Utility function over state-contingent consumption bundles -/
  U : (Fin S → Fin L → ℝ) → ℝ
  /-- Endowment ω_{si} ∈ ℝ^L for each state s -/
  endowment : Fin S → Fin L → ℝ
  /-- Prices for contingent first-good commodities at t=0 -/
  q : Fin S → ℝ
  /-- Spot prices in each state s at t=1 -/
  p : Fin S → Fin L → ℝ
  /-- Proof that L ≥ 1 (good 1 must exist) -/
  hL : 0 < L

/-- Feasibility for consumer i's sequential trade problem. -/
def SequentialTradeConsumerProblem.IsFeasible {L S : ℕ}
    (prob : SequentialTradeConsumerProblem L S)
    (x : Fin S → Fin L → ℝ) (z : Fin S → ℝ) : Prop :=
  (∀ s l, 0 ≤ x s l) ∧
  ∑ s : Fin S, prob.q s * z s ≤ 0 ∧
  ∀ s : Fin S,
    ∑ l : Fin L, prob.p s l * x s l ≤
      ∑ l : Fin L, prob.p s l * prob.endowment s l +
        prob.p s ⟨0, prob.hL⟩ * z s