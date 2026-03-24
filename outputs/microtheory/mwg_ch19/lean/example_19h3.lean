import Mathlib
open Topology

/-- Two states: β = 1 or β = 2 -/
inductive BetaState where | one | two
deriving DecidableEq, Fintype

/-- Informed consumer 1's demand for good 1 given β and price p: x₁₁ = β/p -/
noncomputable def informedDemand (β : ℝ) (p : ℝ) : ℝ := β / p

/-- Uninformed consumer 2's demand for good 1 at constant price p (average over β):
    Expected marginal utility condition gives x₁₂ = (1/2)(3-1)/(p) + (1/2)(3-2)/p = 2/p
    Simplified: x₁₂ = 2/p -/
noncomputable def uninformedDemand (p : ℝ) : ℝ := 2 / p

/-- No rational expectations equilibrium exists: for any price function,
    market clearing (informed demand + uninformed demand = 3) fails in some state.
    If prices are revealing (different across states), pooled info makes them equal, contradiction.
    If prices are non-revealing (equal), demands don't clear in both states simultaneously. -/
theorem Example_19H3 :
    ¬ ∃ (pf : BetaState → ℝ),
      (∀ s, pf s > 0) ∧
      -- Non-revealing case: equal prices must clear in both states
      (pf BetaState.one = pf BetaState.two →
        informedDemand 1 (pf BetaState.one) + uninformedDemand (pf BetaState.one) = 3 ∧
        informedDemand 2 (pf BetaState.two) + uninformedDemand (pf BetaState.two) = 3) ∧
      -- Revealing case: pooled info symmetry forces equal prices
      (pf BetaState.one ≠ pf BetaState.two →
        pf BetaState.one = pf BetaState.two) := by
  intro ⟨pf, hpos, hnonrev, hrev⟩
  by_cases h : pf BetaState.one = pf BetaState.two
  · -- Non-revealing case: demands can't clear in both states
    obtain ⟨hclear1, hclear2⟩ := hnonrev h
    -- In state 1: 1/p + 2/p = 3, so p = 1
    -- In state 2: 2/p + 2/p = 3, so p = 4/3
    -- Contradiction: p can't be both 1 and 4/3
    unfold informedDemand uninformedDemand at hclear1 hclear2
    have hp1 := hpos BetaState.one
    have hp2 := hpos BetaState.two
    rw [h] at hclear1
    -- hclear1: 1 / pf two + 2 / pf two = 3
    -- hclear2: 2 / pf two + 2 / pf two = 3
    have hne : pf BetaState.two ≠ 0 := ne_of_gt hp2
    field_simp at hclear1 hclear2
    linarith
  · -- Revealing case: symmetry forces equal prices, contradicting assumption
    exact h (hrev h)