import Mathlib

open Set Finset

-- We formalize the core mathematical content:
-- Given a compact feasible set and continuous utility functions,
-- the utility possibility set U = U' - ℝ^I_+ is closed and bounded above.

variable {I : Type*} [Fintype I]

/-- The utility possibility set: all vectors dominated by some image point -/
def UtilityPossibilitySet (U' : Set (I → ℝ)) : Set (I → ℝ) :=
  {u | ∃ u' ∈ U', ∀ i, u i ≤ u' i}