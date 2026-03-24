import Mathlib

open Filter Topology

/-- A planning problem with feasible paths and a utility functional. -/
structure PlanningProblem (α : Type*) [TopologicalSpace α] where
  feasibleSet : Set α
  utility : α → ℝ

/-- Proposition 20.D.5: If the feasible set is compact and nonempty, and the utility
    function is continuous, then the planning problem attains a maximum. -/
theorem Proposition_20D5 {α : Type*} [TopologicalSpace α]
    (P : PlanningProblem α)
    (hne : P.feasibleSet.Nonempty)
    (hcompact : IsCompact P.feasibleSet)
    (hcont : ContinuousOn P.utility P.feasibleSet) :
    ∃ x ∈ P.feasibleSet, ∀ y ∈ P.feasibleSet, P.utility y ≤ P.utility x := by
  obtain ⟨x, hx, hmax⟩ := hcompact.exists_isMaxOn hne hcont
  exact ⟨x, hx, fun y hy => hmax hy⟩