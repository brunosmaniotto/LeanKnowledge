import Mathlib
open BigOperators

/-- A coalition S blocks an allocation x if the coalition members can redistribute
    their own total endowment among themselves so that every member is at least
    as well off and at least one member is strictly better off. -/
theorem Claim_5_1_f
    {Agent : Type*} [Fintype Agent] [DecidableEq Agent]
    {Good : Type*} [Fintype Good]
    (utility : Agent → (Good → ℝ) → ℝ)
    (endowment : Agent → (Good → ℝ))
    (x : Agent → (Good → ℝ))
    (S : Finset Agent)
    (hS : S.Nonempty)
    (x' : Agent → (Good → ℝ))
    -- The coalition can redistribute: total allocation to S equals total endowment of S
    (feasible : ∀ g : Good, ∑ i ∈ S, x' i g = ∑ i ∈ S, endowment i g)
    -- Every member of S is weakly better off
    (weakly_better : ∀ i ∈ S, utility i (x' i) ≥ utility i (x i))
    -- At least one member of S is strictly better off
    (strictly_better : ∃ i ∈ S, utility i (x' i) > utility i (x i)) :
    -- Then the allocation x is blocked by coalition S
    ∃ (T : Finset Agent), T.Nonempty ∧
      ∃ y : Agent → (Good → ℝ),
        (∀ g : Good, ∑ i ∈ T, y i g = ∑ i ∈ T, endowment i g) ∧
        (∀ i ∈ T, utility i (y i) ≥ utility i (x i)) ∧
        (∃ i ∈ T, utility i (y i) > utility i (x i)) :=
  ⟨S, hS, x', feasible, weakly_better, strictly_better⟩