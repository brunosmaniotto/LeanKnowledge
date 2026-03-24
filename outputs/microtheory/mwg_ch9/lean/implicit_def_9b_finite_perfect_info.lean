import Mathlib
open Topology

/-- A finite game of perfect information is an extensive-form game in which
    every information set contains a single decision node and there is a
    finite number of such nodes. This is the general class of games to which
    backward induction applies. -/
structure FinitePerfectInfoGame where
  /-- Type of decision nodes in the game tree -/
  Node : Type*
  /-- Type of players -/
  Player : Type*
  /-- Type of actions -/
  Action : Type*
  /-- Which player moves at each decision node -/
  toMove : Node → Player
  /-- Available actions at each decision node -/
  actions : Node → Finset Action
  /-- Information set of a node: the set of nodes indistinguishable
      to the acting player at that point -/
  infoSet : Node → Set Node
  /-- **Perfect information**: every information set is a singleton,
      i.e., the player always knows exactly which node they are at -/
  perfect_info : ∀ n, infoSet n = {n}
  /-- **Finiteness**: there are finitely many decision nodes -/
  finite_nodes : Finite Node