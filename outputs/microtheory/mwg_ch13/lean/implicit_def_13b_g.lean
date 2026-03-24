import Mathlib

/-- An allocation is an **ex ante constrained Pareto optimum** if, among all allocations
feasible without observing worker types (i.e., incentive-compatible allocations),
no alternative raises aggregate surplus.

By the context of MWG §13.B, aggregate surplus equals the ex ante expected utility
of a risk-neutral unborn worker with type distribution `F`, so maximizing surplus
over the feasible set is equivalent to maximizing that expected utility. -/
def IsExAnteConstrainedParetoOptimum
    (Allocation : Type*)
    (feasible : Set Allocation)
    (aggregateSurplus : Allocation → ℝ)
    (a : Allocation) : Prop :=
  a ∈ feasible ∧ ∀ a' ∈ feasible, aggregateSurplus a' ≤ aggregateSurplus a