import Mathlib
open Topology

/-- A finite game is a game where the set of nodes is finite,
    ensuring the game ends after a finite number of moves. -/
class FiniteGame (G : Type*) [DecidableEq G] where
  /-- The set of all nodes in the game tree. -/
  nodes : Finset G
  /-- Every node of the game is contained in the finite node set. -/
  mem_nodes : ∀ (n : G), n ∈ nodes