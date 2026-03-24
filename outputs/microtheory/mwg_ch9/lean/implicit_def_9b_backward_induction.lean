import Mathlib
open Topology

/-- Backward induction (backward programming) for finite extensive-form games.

A solution procedure that works backwards from terminal decision nodes to the root,
first solving for optimal behavior at the end of the game, then determining optimal
behavior at earlier nodes given anticipation of this later optimal play.

The key property is that the resulting strategy specifies optimal behavior at
every decision node — not just at the root — yielding subgame-perfect play. -/
structure BackwardInduction (Node : Type) (Action : Type) [DecidableEq Node] [DecidableEq Action] where
  /-- Available actions at each decision node -/
  actions : Node → Finset Action
  /-- Continuation payoff from a node under a given strategy profile -/
  payoff : (Node → Action) → Node → ℝ
  /-- The strategy profile computed by backward induction -/
  strategy : Node → Action
  /-- The selected action is always among the available actions -/
  strategy_valid : ∀ n, (actions n).Nonempty → strategy n ∈ actions n
  /-- Optimality at every decision node: no single-node deviation improves payoff,
      ensuring players' strategies specify optimal behavior throughout the game -/
  optimal_at_every_node : ∀ (n : Node) (a : Action),
    a ∈ actions n → payoff strategy n ≥ payoff (Function.update strategy n a) n