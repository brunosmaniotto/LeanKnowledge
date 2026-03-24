import Mathlib
open Topology

/-- If every consumer is at least as well off under the new policy (potential compensation),
    then any monotone (increasing) social welfare function ranks the new policy at least as highly. -/
theorem potential_compensation_implies_welfare_improvement
    {n : ℕ}
    (u u' : Fin n → ℝ)
    (W : (Fin n → ℝ) → ℝ)
    (hW : Monotone W)
    (h : ∀ i, u i ≤ u' i) :
    W u ≤ W u' := by
  apply hW
  exact h