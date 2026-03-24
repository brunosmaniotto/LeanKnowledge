import Mathlib
open Topology

/-- A node in a game tree is either a decision node (where a player chooses)
    or a terminal node (where the game ends and payoffs are assigned). -/
inductive NodeKind (Player : Type*) where
  | decision : Player → NodeKind Player
  | terminal : NodeKind Player
deriving DecidableEq

/-- A game tree: a rooted tree with decision and terminal nodes,
    branches representing actions, and payoffs at terminal nodes.
    `Node`, `Action`, `Player` are the types of nodes, actions, and players;
    `n` is the number of players (for payoff vectors). -/
structure GameTree (Node Action Player : Type*) (n : ℕ) where
  /-- The root (initial decision node). -/
  root : Node
  /-- The children of a node, each labeled by the action taken. -/
  children : Node → List (Action × Node)
  /-- Classification of each node as decision or terminal. -/
  kind : Node → NodeKind Player
  /-- Payoff vector assigned to each terminal node. -/
  payoff : Node → Fin n → ℝ
  /-- The root is a decision node. -/
  root_is_decision : ∃ p, kind root = NodeKind.decision p
  /-- Terminal nodes have no children. -/
  terminal_no_children :
    ∀ v, (∃ p, kind v = NodeKind.decision p) ∨ children v = []