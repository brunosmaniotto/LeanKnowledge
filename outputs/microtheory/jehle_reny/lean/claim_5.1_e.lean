import Mathlib
open Topology

/-- A barter equilibrium (core allocation) requires that no individual consumer
    can do better by consuming their endowment. We prove: if x is in the core,
    then u i (x i) ≥ u i (e i) for all i. -/
theorem barter_equilibrium_individual_rationality
    {I : Type*} [DecidableEq I]
    {X : Type*}
    (u : I → X → ℝ)
    (e : I → X)
    (x : I → X)
    -- x is in the core: no single agent can block by consuming their endowment
    (hcore : ∀ i : I, ¬ (u i (e i) > u i (x i))) :
    ∀ i : I, u i (x i) ≥ u i (e i) := by
  intro i
  by_contra h
  push_neg at h
  exact hcore i h