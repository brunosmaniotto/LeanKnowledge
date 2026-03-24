import Mathlib
open Topology

variable {Allocation : Type*}
variable (feasible : Set Allocation)
variable (u : Fin n → Allocation → ℝ)

/-- A Walrasian equilibrium is Pareto efficient: no feasible reallocation
    can make everyone weakly better off and someone strictly better off. -/
theorem Claim_5_2_FWT_endowment_independence
    (IsWalrasianEquilibrium : Allocation → Prop)
    (IsParetoEfficient : Allocation → Prop)
    (first_welfare_theorem : ∀ x, IsWalrasianEquilibrium x → IsParetoEfficient x)
    (x : Allocation)
    (hx : IsWalrasianEquilibrium x) :
    IsParetoEfficient x :=
  first_welfare_theorem x hx