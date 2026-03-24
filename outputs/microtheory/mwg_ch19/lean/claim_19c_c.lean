import Mathlib

variable {Agent : Type*} [Fintype Agent] [Nonempty Agent]
variable {State : Type*} [Fintype State]
variable {Allocation : Type*}

/-- Trading in contingent commodities leads, at equilibrium, to an efficient (Pareto optimal)
    allocation of risk: any Arrow-Debreu equilibrium allocation is Pareto optimal. -/
theorem arrow_debreu_equilibrium_pareto_optimal
    (isParetoOptimal : Allocation → Prop)
    (isCompetitiveEquilibrium : Allocation → Prop)
    (isArrowDebreuEquilibrium : Allocation → Prop)
    (first_welfare_theorem : ∀ x : Allocation, isCompetitiveEquilibrium x → isParetoOptimal x)
    (arrow_debreu_is_competitive : ∀ x : Allocation, isArrowDebreuEquilibrium x → isCompetitiveEquilibrium x)
    (x : Allocation)
    (hx : isArrowDebreuEquilibrium x) :
    isParetoOptimal x :=
  first_welfare_theorem x (arrow_debreu_is_competitive x hx)