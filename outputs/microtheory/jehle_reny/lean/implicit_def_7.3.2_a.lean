import Mathlib
open Topology

/-- An extensive form game with decision nodes, actions, and players. -/
structure ExtensiveFormGame where
  Player : Type*
  Node : Type*
  Action : Type*
  playerAt : Node → Player
  actionsAt : Node → Set Action

/-- A pure strategy for player `i` in an extensive form game `G` is a complete
    contingent plan: it assigns to each of player `i`'s decision nodes an action
    available at that node. A strategy specifies choices at every decision node,
    including those that may be unreachable due to earlier deviations. -/
structure PureStrategy (G : ExtensiveFormGame) (i : G.Player) where
  play : G.Node → G.Action
  mem_actionsAt : ∀ x : G.Node, G.playerAt x = i → play x ∈ G.actionsAt x