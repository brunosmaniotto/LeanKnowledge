import Mathlib
open Topology

/-- A constrained Pareto optimal allocation: one that cannot be Pareto improved
    by any central authority subject to the same informational constraints
    as market participants (i.e., unable to observe private types directly). -/
structure ConstrainedParetoOptimal
    (Agent : Type*) [Fintype Agent] [DecidableEq Agent]
    (TypeSpace : Agent → Type*)
    (Outcome : Type*)
    (utility : (i : Agent) → TypeSpace i → Outcome → ℝ)
    (feasible : ((i : Agent) → TypeSpace i → Outcome) → Prop) where
  /-- The allocation rule: assigns an outcome given each agent's reported type. -/
  allocation : (i : Agent) → TypeSpace i → Outcome
  /-- The allocation must itself be feasible (respecting informational constraints). -/
  is_feasible : feasible allocation
  /-- No feasible alternative allocation Pareto dominates: there is no other
      feasible allocation that makes every agent weakly better off for every type
      and strictly better off for some agent and type. -/
  no_pareto_improvement :
    ∀ alloc' : (i : Agent) → TypeSpace i → Outcome,
      feasible alloc' →
      (∀ (i : Agent) (θ : TypeSpace i), utility i θ (alloc' i θ) ≥ utility i θ (allocation i θ)) →
      (∀ (i : Agent) (θ : TypeSpace i), utility i θ (alloc' i θ) = utility i θ (allocation i θ))