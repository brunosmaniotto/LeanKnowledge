import Mathlib

open Set

variable {α : Type u} [MeasurableSpace α]

/-- A σ-algebra is closed under countable intersections. -/
theorem sigma_algebra_is_delta_algebra (f : ℕ → Set α) (h : ∀ i, MeasurableSet (f i)) :
    MeasurableSet (⋂ i, f i) := by
  rw [Set.iInter_eq_compl_iUnion_compl]
  exact MeasurableSet.compl (MeasurableSet.iUnion (fun i => MeasurableSet.compl (h i)))