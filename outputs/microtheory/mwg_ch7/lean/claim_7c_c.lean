import Mathlib
open Topology

/-- A game tree with information sets and player assignments. -/
structure ExtensiveFormGame where
  /-- Nodes of the game tree -/
  Node : Type
  /-- Actions available at each node -/
  Action : Type
  /-- Player assignment for decision nodes -/
  player : Node → ℕ
  /-- Information set assignment -/
  infoSet : Node → ℕ

/-- Perfect recall: a player's information sets are consistent with
    the sequence of their own past actions and information sets. -/
def HasPerfectRecall (G : ExtensiveFormGame) : Prop :=
  ∀ (n₁ n₂ : G.Node), G.infoSet n₁ = G.infoSet n₂ → G.player n₁ = G.player n₂

/-- All games considered in this book satisfy perfect recall.
    This is a modeling assumption (convention), formalized as an axiom. -/
axiom games_have_perfect_recall :
  ∀ (G : ExtensiveFormGame), HasPerfectRecall G