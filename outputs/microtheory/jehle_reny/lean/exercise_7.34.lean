import Mathlib
open Topology

structure ExtensiveFormGame where
  Node : Type*
  root : Node
  nodes : Set Node
  root_mem : root ∈ nodes
  successors : Node → Set Node
  successors_closed : ∀ n ∈ nodes, successors n ⊆ nodes

def ExtensiveFormGame.IsSubgame (G : ExtensiveFormGame) (S : Set G.Node) : Prop :=
  ∃ r ∈ S, S ⊆ G.nodes ∧ ∀ n ∈ S, G.successors n ⊆ S