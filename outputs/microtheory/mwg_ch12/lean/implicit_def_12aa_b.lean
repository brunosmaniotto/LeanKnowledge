import Mathlib

noncomputable def minimaxPayoff
    (ActionI ActionJ : Type) [Fintype ActionI] [Fintype ActionJ]
    (payoff : ActionI → ActionJ → ℝ) : ℝ :=
  ⨅ aj : ActionJ, ⨆ ai : ActionI, payoff ai aj

def IsIndividuallyRational
    (ActionI ActionJ : Type) [Fintype ActionI] [Fintype ActionJ]
    (payoff : ActionI → ActionJ → ℝ)
    (v : ℝ) : Prop :=
  v > minimaxPayoff ActionI ActionJ payoff