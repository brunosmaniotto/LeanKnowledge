import Mathlib

open Finset
open Topology

/-- A feasible allocation is Pareto optimal iff its utility vector lies on the Pareto frontier. -/
theorem Proposition_16_E_1
    {I : Type*} [Fintype I] [DecidableEq I]
    -- U is the set of attainable utility vectors (from feasible allocations)
    (U : Set (I → ℝ))
    -- UP is the Pareto frontier: vectors in U not dominated by any other in U
    (UP : Set (I → ℝ))
    (hUP : UP = {v ∈ U | ¬∃ v' ∈ U, (∀ i, v i ≤ v' i) ∧ (∃ i, v i < v' i)})
    -- u is the utility vector of the allocation in question
    (u : I → ℝ)
    (hu : u ∈ U)
    -- Pareto optimality means no feasible utility vector dominates u
    (pareto_opt : Prop := ¬∃ v' ∈ U, (∀ i, u i ≤ v' i) ∧ (∃ i, u i < v' i)) :
    (¬∃ v' ∈ U, (∀ i, u i ≤ v' i) ∧ (∃ i, u i < v' i)) ↔ u ∈ UP := by
  subst hUP
  simp only [Set.mem_sep_iff]
  exact ⟨fun h => ⟨hu, h⟩, fun h => h.2⟩