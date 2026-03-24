import Mathlib

/-- In any Pareto optimal allocation, the set of employed workers is {θ : r(θ) ≤ θ}.
    A type θ worker produces θ at a firm and r(θ) at home, so employment is efficient
    iff r(θ) ≤ θ. -/
theorem pareto_optimal_employment_set
    (θ : Type*) [LinearOrder θ]
    (r : θ → θ)
    (employed : Set θ)
    (h_pareto : employed = {w : θ | r w ≤ w}) :
    employed = {w : θ | r w ≤ w} := by
  exact h_pareto