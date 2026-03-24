import Mathlib
open Topology

/-- The implicit assumptions maintained prior to MWG Section 9.5.6.

Individuals cannot be forced to give up their income and have no property
rights over social states. When an individual does not participate:
(1) their income is unchanged, and (2) the set of social states available
to the remaining individuals is also unchanged. -/
structure NonParticipationAssumptions (I : Type*) (S : Type*) [DecidableEq I] where
  /-- Initial income (endowment) of each individual. -/
  income : I → ℝ
  /-- Feasible social states given a set of participating individuals. -/
  feasibleStates : Finset I → Set S
  /-- Income outcome for individual `i` when participants are `P` and state `s` is chosen. -/
  outcomeIncome : Finset I → S → I → ℝ
  /-- Individuals cannot be forced to give up income: every individual's
      outcome income is at least their initial income. -/
  no_forced_income_loss : ∀ (P : Finset I) (s : S) (i : I),
    outcomeIncome P s i ≥ income i
  /-- When individual `i` does not participate, their income is unchanged. -/
  nonpart_income_unchanged : ∀ (P : Finset I) (s : S) (i : I),
    i ∉ P → outcomeIncome P s i = income i
  /-- When individual `i` does not participate, the feasible set of social
      states for the remaining individuals is unchanged. -/
  nonpart_states_unchanged : ∀ (P : Finset I) (i : I),
    i ∉ P → feasibleStates P = feasibleStates (insert i P)