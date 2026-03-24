import Mathlib

/-- A first-best optimization problem: constraints come only from technology and resources,
    with no restrictions on available policy instruments. -/
structure FirstBestProblem (α : Type*) where
  /-- The set of all feasible allocations given technology and resource constraints -/
  feasibleSet : Set α
  /-- The objective function to be maximized -/
  objective : α → ℝ
  /-- The feasible set is nonempty -/
  feasible_nonempty : feasibleSet.Nonempty

/-- A second-best optimization problem: in addition to technology and resource constraints,
    there are further restrictions on usable policy instruments (legal, institutional,
    or informational). -/
structure SecondBestProblem (α : Type*) extends FirstBestProblem α where
  /-- The restricted feasible set after imposing instrument constraints -/
  restrictedSet : Set α
  /-- The restricted set is a subset of the full feasible set -/
  restricted_sub : restrictedSet ⊆ feasibleSet
  /-- The restricted set is nonempty -/
  restricted_nonempty : restrictedSet.Nonempty