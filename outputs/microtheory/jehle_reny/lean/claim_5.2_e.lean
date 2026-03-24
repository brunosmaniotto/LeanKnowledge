import Mathlib

/-- A Robinson Crusoe economy: one consumer, one producer, feasible set of consumption bundles. -/
theorem Claim_5_2_e
    {Bundle : Type*}
    (feasible : Set Bundle)
    (u : Bundle → ℝ)
    (xStar : Bundle)
    (hFeasible : xStar ∈ feasible)
    (hEquilibrium : ∀ x ∈ feasible, u x ≤ u xStar) :
    ∀ x ∈ feasible, u x ≤ u xStar := by
  exact hEquilibrium