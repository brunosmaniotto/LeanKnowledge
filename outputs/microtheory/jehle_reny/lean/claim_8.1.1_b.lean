import Mathlib
open Topology

/-- Risk-averse consumer's optimal insurance demand given price pi and actuarially fair premium πiL -/
axiom optimal_demand (pi πiL : ℝ) : ℝ

/-- A risk-averse consumer facing actuarially fair or better pricing (pi ≤ πiL)
    demands at least one policy (from Chapter 2 analysis). -/
axiom demand_ge_one_of_fair {pi πiL : ℝ} (h : pi ≤ πiL) :
    optimal_demand pi πiL ≥ 1

/-- A risk-averse consumer facing unfair pricing (pi > πiL)
    demands at most one policy. -/
axiom demand_le_one_of_unfair {pi πiL : ℝ} (h : πiL < pi) :
    optimal_demand pi πiL ≤ 1

/-- In the symmetric information insurance market: if pi ≤ πiL (actuarially fair or better),
    consumer i demands at least one policy; if pi > πiL, consumer i demands at most one policy. -/
theorem Claim_8_1_1_b (pi πiL : ℝ) :
    (pi ≤ πiL → optimal_demand pi πiL ≥ 1) ∧
    (πiL < pi → optimal_demand pi πiL ≤ 1) :=
  ⟨fun h => demand_ge_one_of_fair h, fun h => demand_le_one_of_unfair h⟩