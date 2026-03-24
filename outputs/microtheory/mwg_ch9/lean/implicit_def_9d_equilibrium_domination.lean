import Mathlib
open Topology

/-- A strategy `s` is equilibrium dominated for player `i` if the player's equilibrium
    strategy guarantees at least the equilibrium payoff, and `s` yields strictly less
    than the equilibrium payoff against every possible opponent response. -/
def isEquilibriumDominated
    {Player Strategy Response : Type*}
    (payoff : Strategy → Response → ℝ)
    (eqPayoff : ℝ)
    (eqStrategy : Strategy)
    (s : Strategy) : Prop :=
  (∀ r : Response, eqPayoff ≤ payoff eqStrategy r) ∧
  (∀ r : Response, payoff s r < eqPayoff)