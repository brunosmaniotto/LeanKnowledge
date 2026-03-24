import Mathlib

open Finset BigOperators
open Topology
open BigOperators

/-- A sunspot set: states where probabilities are uniform across consumers
    and fundamentals (utility, endowments) don't vary across states. -/
structure IsSunspotSet
    (S : Type*) [Fintype S] [DecidableEq S]
    (I : Type*) [Fintype I]
    (π : I → S → ℝ)
    (u : S → I → ℝ → ℝ)
    (ω : S → I → ℝ) : Prop where
  /-- Probability estimates are the same across consumers -/
  uniform_prob : ∀ (s : S) (i i' : I), π i s = π i' s
  /-- Bernoulli utility functions are uniform across states -/
  uniform_utility : ∀ (s s' : S) (i : I) (x : ℝ), u s i x = u s' i x
  /-- Endowments are uniform across states -/
  uniform_endowment : ∀ (s s' : S) (i : I), ω s i = ω s' i

/-- A sunspot equilibrium: a Radner equilibrium where consumption varies
    across states despite all states being sunspots. -/
structure SunspotEquilibrium
    (S : Type*) [Fintype S] [DecidableEq S]
    (I : Type*) [Fintype I]
    (π : I → S → ℝ)
    (u : S → I → ℝ → ℝ)
    (ω : S → I → ℝ)
    (x : S → I → ℝ)
    (p : S → ℝ)
    (q : S → ℝ) : Prop where
  /-- The states form a sunspot set -/
  sunspot : IsSunspotSet S I π u ω
  /-- Consumption varies across states (not all equal) -/
  consumption_varies : ∃ (s s' : S) (i : I), x s i ≠ x s' i
  /-- Market clearing: total consumption equals total endowment in each state -/
  market_clearing : ∀ (s : S), ∑ i : I, x s i = ∑ i : I, ω s i
  /-- Budget feasibility for each consumer -/
  budget_feasible : ∀ (i : I), ∑ s : S, q s * x s i ≤ ∑ s : S, q s * ω s i