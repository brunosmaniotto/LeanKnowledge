import Mathlib

open Topology

/-- A Nash equilibrium is a strategy profile where no agent can unilaterally
    improve their payoff. -/
structure NashEquilibrium
    {Agent : Type*} [Fintype Agent] [DecidableEq Agent]
    {Strategy : Agent → Type*}
    (payoff : (∀ i, Strategy i) → Agent → ℝ) where
  /-- The strategy profile -/
  profile : ∀ i, Strategy i
  /-- No agent can improve by unilateral deviation -/
  is_equilibrium : ∀ (i : Agent) (s' : Strategy i),
    payoff profile i ≥ payoff (Function.update profile i s') i