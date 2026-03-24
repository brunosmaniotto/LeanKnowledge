import Mathlib

open BigOperators
open Topology

/-- At a short-run competitive equilibrium price p*: (i) each buyer purchases
    their utility-maximising quantity, (ii) each firm sells its profit-maximising
    output, and (iii) no agent has incentive to change behaviour (market clears
    with all agents at their individual optima). -/
theorem claim_4_1_e
    {I J : Type*} [Fintype I] [Fintype J]
    (utility : I → ℝ → ℝ → ℝ)   -- buyer i's utility from quantity q at price p
    (profit : J → ℝ → ℝ → ℝ)    -- firm j's profit from quantity q at price p
    (qd : I → ℝ → ℝ)             -- buyer i's demand at price p
    (qs : J → ℝ → ℝ)             -- firm j's supply at price p
    (p_star : ℝ)
    -- Each buyer's demand maximizes utility at p*
    (hd_opt : ∀ i, ∀ q : ℝ, utility i (qd i p_star) p_star ≥ utility i q p_star)
    -- Each firm's supply maximizes profit at p*
    (hs_opt : ∀ j, ∀ q : ℝ, profit j (qs j p_star) p_star ≥ profit j q p_star)
    -- Market clears: aggregate demand = aggregate supply
    (h_clears : ∑ i : I, qd i p_star = ∑ j : J, qs j p_star) :
    -- (i)  Every buyer is at optimum
    (∀ i, ∀ q, utility i (qd i p_star) p_star ≥ utility i q p_star) ∧
    -- (ii) Every firm is at optimum
    (∀ j, ∀ q, profit j (qs j p_star) p_star ≥ profit j q p_star) ∧
    -- (iii) Market clears — no agent can improve by deviating
    (∑ i : I, qd i p_star = ∑ j : J, qs j p_star) := by
  exact ⟨hd_opt, hs_opt, h_clears⟩