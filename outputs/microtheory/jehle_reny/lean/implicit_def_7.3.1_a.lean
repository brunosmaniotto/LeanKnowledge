import Mathlib
open Topology

/-- A game tree: the diagrammatic representation of an extensive form game.
    Nodes are decision nodes (labeled by the acting player) or terminal nodes
    (assigned payoff vectors). The root is a distinguished chance node.
    Information sets group decision nodes that a player cannot distinguish. -/
structure GameTree (Player : Type*) (Action : Type*) (numPlayers : ℕ) where
  /-- The type of nodes in the game tree -/
  Node : Type*
  /-- The initial (chance) node, labeled C -/
  root : Node
  /-- Decision nodes, each labeled with the player whose turn it is -/
  decisionNodes : Set Node
  /-- Terminal (end) nodes where the game ends -/
  terminalNodes : Set Node
  /-- The player who moves at each decision node -/
  playerAt : Node → Player
  /-- Actions available at each node (lines between nodes in the diagram) -/
  actionsAt : Node → Set Action
  /-- Payoff vector at terminal nodes; the i-th entry is player i's payoff -/
  payoff : Node → Fin numPlayers → ℝ
  /-- Information sets: collections of indistinguishable decision nodes,
      depicted as dashed ellipses in the diagram -/
  informationSets : Set (Set Node)

/-- An information set is a singleton if it contains exactly one decision node.
    Singleton information sets are not enclosed by a dashed ellipse in the diagram. -/
def GameTree.isSingletonInfoSet {Player Action : Type*} {n : ℕ}
    (G : GameTree Player Action n) (H : Set G.Node) : Prop :=
  ∃ x, H = {x}