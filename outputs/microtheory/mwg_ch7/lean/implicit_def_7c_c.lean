import Mathlib
open Topology

structure InformationSet (Player : Type*) (Node : Type*) (Action : Type*)
    (owner_of : Node → Player) (actions_at : Node → Set Action) where
  player : Player
  nodes : Set Node
  nonempty : nodes.Nonempty
  owns : ∀ n ∈ nodes, owner_of n = player
  indistinguishable : ∀ n₁ ∈ nodes, ∀ n₂ ∈ nodes, actions_at n₁ = actions_at n₂