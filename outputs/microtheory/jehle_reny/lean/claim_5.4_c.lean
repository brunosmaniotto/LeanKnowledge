import Mathlib

open BigOperators
open Topology

/-- The Walrasian equilibrium of the contingent commodity economy can be implemented
    via binding contracts at date zero. Market clearing (condition 5.6) ensures:
    (1) feasibility at each realized date-state — net demand equals production, and
    (2) no further trade — the value of excess demand is zero at every date-state. -/
theorem Claim_5_4_c
    {I J K T S : ℕ}
    (p : Fin K → Fin T → Fin S → ℝ)
    (x : Fin I → Fin K → Fin T → Fin S → ℝ)
    (y : Fin J → Fin K → Fin T → Fin S → ℝ)
    (ω : Fin I → Fin K → Fin T → Fin S → ℝ)
    -- Market clearing at date zero (condition 5.6):
    -- total demand = total endowment + total production for each good-date-state
    (market_clearing : ∀ k t s,
      ∑ i : Fin I, x i k t s = ∑ i : Fin I, ω i k t s + ∑ j : Fin J, y j k t s) :
    -- (1) At each (t,s), contracted net consumption = production (feasibility)
    (∀ t s k, ∑ i : Fin I, x i k t s - ∑ i : Fin I, ω i k t s =
      ∑ j : Fin J, y j k t s) ∧
    -- (2) Value of excess demand is zero (no incentive for further trade)
    (∀ t s, ∑ k : Fin K,
      p k t s * (∑ i : Fin I, x i k t s - ∑ i : Fin I, ω i k t s -
        ∑ j : Fin J, y j k t s) = 0) := by
  refine ⟨fun t s k => ?_, fun t s => ?_⟩
  · linarith [market_clearing k t s]
  · apply Finset.sum_eq_zero
    intro k _
    have h : ∑ i : Fin I, x i k t s - ∑ i : Fin I, ω i k t s -
        ∑ j : Fin J, y j k t s = 0 := by linarith [market_clearing k t s]
    rw [h, mul_zero]