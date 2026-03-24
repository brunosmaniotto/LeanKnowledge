import Mathlib
open Topology

/-- A constrained (second-best) Pareto optimum: an allocation that cannot be
    Pareto improved by any authority unable to observe agents' private information.

    - `Agent`: the type of agents in the economy
    - `Allocation`: the type of feasible allocations
    - `PrivateInfo`: the type of each agent's private information
    - `utility`: each agent's utility from an allocation (may depend on private info)
    - `feasible`: which allocations are achievable
    - `observableAllocs`: the set of allocations reachable by an authority that
      cannot condition on private information (incentive-compatible / information-
      constrained allocations)
    - `allocation`: the candidate allocation
    - `is_feasible`: the candidate must itself be feasible
    - `is_observable`: the candidate must be in the information-constrained set
    - `no_pareto_improvement`: no other information-constrained feasible allocation
      makes every agent weakly better off and some agent strictly better off -/
structure ConstrainedParetoOptimum
    (Agent : Type*) [Fintype Agent] [DecidableEq Agent]
    (Allocation : Type*)
    (PrivateInfo : Type*)
    (utility : Agent → PrivateInfo → Allocation → ℝ)
    (feasible : Set Allocation)
    (observableAllocs : Set Allocation) where
  allocation : Allocation
  is_feasible : allocation ∈ feasible
  is_observable : allocation ∈ observableAllocs
  no_pareto_improvement :
    ¬∃ a' ∈ feasible ∩ observableAllocs,
      (∀ (i : Agent) (θ : PrivateInfo), utility i θ a' ≥ utility i θ allocation) ∧
      (∃ (j : Agent) (θ : PrivateInfo), utility j θ a' > utility j θ allocation)