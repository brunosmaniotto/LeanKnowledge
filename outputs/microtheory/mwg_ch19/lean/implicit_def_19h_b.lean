import Mathlib

open Finset BigOperators
open Topology
open BigOperators

/-- Posterior probability of state s' given signal σ(s), via Bayesian updating. -/
noncomputable def posteriorProbability
    {State : Type*} [Fintype State] [DecidableEq State]
    {Signal : Type*} [DecidableEq Signal]
    (σ : State → Signal)
    (π : State → ℝ)
    (s s' : State) : ℝ :=
  if σ s' = σ s then
    π s' / ∑ s'' ∈ Finset.univ.filter (fun s'' => σ s'' = σ s), π s''
  else
    0

/-- Utility conditional on signal σ(s): u(x_i | σ(s)) = Σ_{s'} π(s'|σ(s)) · u_{s'}(x_i). -/
noncomputable def conditionalUtility
    {State : Type*} [Fintype State] [DecidableEq State]
    {Signal : Type*} [DecidableEq Signal]
    (σ : State → Signal)
    (π : State → ℝ)
    (u : State → ℝ)
    (s : State) : ℝ :=
  ∑ s' ∈ Finset.univ, posteriorProbability σ π s s' * u s'