import Mathlib

open BigOperators Finset

/-- The set of feasible allocations in an exchange economy: all allocations
    that exhaust exactly the aggregate endowment for every good. (MWG Def 5.1) -/
def feasibleAllocations
    {I : Type*} [Fintype I]
    {L : ℕ}
    (e : I → (Fin L → ℝ)) : Set (I → (Fin L → ℝ)) :=
  {x | ∑ i, x i = ∑ i, e i}