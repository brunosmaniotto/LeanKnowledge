import Mathlib

/-- The Pareto frontier of a utility possibility set `U`.
    A utility vector is on the frontier if no other vector in `U`
    weakly dominates it with strict improvement in at least one coordinate. -/
def ParetoFrontier {I : Type*} [Fintype I] (U : Set (I → ℝ)) : Set (I → ℝ) :=
  {u ∈ U | ¬∃ u' ∈ U, (∀ i, u i ≤ u' i) ∧ (∃ i, u i < u' i)}