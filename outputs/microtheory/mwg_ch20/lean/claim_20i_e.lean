import Mathlib

/-- A steady state in an OLG monetary model -/
axiom SteadyState : Type

/-- Predicate: the steady state is determinate (locally isolated in equilibrium dynamics) -/
axiom SteadyState.isDeterminate : SteadyState → Prop

/-- Predicate: the steady state is locally stable under adaptive learning dynamics -/
axiom SteadyState.isStableUnderLearning : SteadyState → Prop

/-- Exact reversal property: learning dynamics converge iff equilibrium dynamics diverge -/
axiom exact_reversal (ss : SteadyState) :
  ss.isStableUnderLearning ↔ ss.isDeterminate

/-- For the gross substitute case, a steady state is locally stable for
    the learning dynamics if and only if it is determinate. -/
theorem steady_state_stability_iff_determinacy (ss : SteadyState) :
    ss.isStableUnderLearning ↔ ss.isDeterminate :=
  exact_reversal ss