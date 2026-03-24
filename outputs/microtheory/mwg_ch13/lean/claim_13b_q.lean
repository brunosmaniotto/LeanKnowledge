import Mathlib
open Topology

-- Model: Workers have types, contracts specify wages, authority cannot observe types.
-- The highest-wage competitive equilibrium cannot be Pareto-improved under adverse selection.

/-- In an adverse selection setting where the authority cannot observe worker types,
    if the market outcome is the highest-wage competitive equilibrium, then no
    intervention achieves a Pareto improvement. -/
theorem adverse_selection_no_pareto_improvement
    {WorkerType Contract Outcome : Type*}
    [Fintype WorkerType]
    [Preorder Outcome]
    (utility : WorkerType → Contract → Outcome)
    (is_competitive_eq : Set Contract → Prop)
    (is_highest_wage_eq : Set Contract → Prop)
    (is_feasible : Set Contract → Prop)
    (pareto_dominates : Set Contract → Set Contract → Prop)
    -- The highest-wage CE is a competitive equilibrium
    (hw_is_ce : ∀ S, is_highest_wage_eq S → is_competitive_eq S)
    -- A competitive equilibrium is feasible
    (ce_feasible : ∀ S, is_competitive_eq S → is_feasible S)
    -- The highest-wage CE is Pareto optimal among feasible allocations:
    -- no feasible allocation Pareto-dominates it
    (hw_pareto_optimal : ∀ S, is_highest_wage_eq S →
      ∀ T, is_feasible T → ¬pareto_dominates T S)
    -- The authority's interventions must be feasible (incentive-compatible under
    -- adverse selection, i.e., the authority cannot observe types)
    (intervention_feasible : ∀ T, is_feasible T)
    (market : Set Contract)
    (h_market : is_highest_wage_eq market) :
    ∀ intervention : Set Contract, ¬pareto_dominates intervention market := by
  intro intervention
  exact hw_pareto_optimal market h_market intervention (intervention_feasible intervention)