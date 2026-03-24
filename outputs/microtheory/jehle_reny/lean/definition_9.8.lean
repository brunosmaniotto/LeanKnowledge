import Mathlib
open Topology

/-- An incentive-compatible direct mechanism is individually rational if for each
    agent i and each type t_i ∈ T_i, agent i's expected utility from participating
    in the mechanism and reporting truthfully is at least IR_i(t_i),
    given that the others participate and always report truthfully.

    Here `expected_utility i t_i` is the expected payoff to agent i of type t_i
    under truthful play, and `IR i t_i` is the individual rationality threshold
    (reservation/outside-option utility). -/
def IsIndividuallyRational
    {I : Type*} [Fintype I]
    {T : I → Type*}
    (expected_utility : ∀ i, T i → ℝ)
    (IR : ∀ i, T i → ℝ) : Prop :=
  ∀ (i : I) (t_i : T i), IR i t_i ≤ expected_utility i t_i