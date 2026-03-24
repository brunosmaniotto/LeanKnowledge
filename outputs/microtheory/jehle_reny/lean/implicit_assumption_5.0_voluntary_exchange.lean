import Mathlib
open BigOperators

/-- Voluntary exchange assumption (MWG p.213): trade is the only redistribution
    mechanism, it is non-coercive, and consumers accept trades only if
    weakly preferred to their endowment. -/
structure VoluntaryExchange
    {I : Type*} {L : Type*} [Fintype I] [Fintype L]
    (endowment : I → L → ℝ)
    (utility : I → (L → ℝ) → ℝ) where
  /-- A trade is a reallocation: net trades sum to zero across consumers. -/
  trade : I → L → ℝ
  /-- Feasibility: aggregate net trade is zero for each commodity. -/
  feasible : ∀ l : L, ∑ i : I, trade i l = 0
  /-- Individual rationality: every consumer is at least as well off
      after trade as at their initial endowment. -/
  individually_rational :
    ∀ i : I, utility i (fun l => endowment i l + trade i l) ≥ utility i (endowment i)