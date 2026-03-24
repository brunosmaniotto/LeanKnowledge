import Mathlib
open Topology

/-- The extensive form representation of a game. -/
structure ExtensiveFormGame where
  Player : Type*
  Node : Type*
  Action : Type*
  Outcome : Type*
  playerAt : Node → Player
  actionsAt : Node → Set Action
  infoSet : Node → Node → Prop
  infoSet_refl : ∀ n, infoSet n n
  infoSet_symm : ∀ n₁ n₂, infoSet n₁ n₂ → infoSet n₂ n₁
  infoSet_trans : ∀ n₁ n₂ n₃, infoSet n₁ n₂ → infoSet n₂ n₃ → infoSet n₁ n₃
  infoSet_same_player : ∀ n₁ n₂, infoSet n₁ n₂ → playerAt n₁ = playerAt n₂
  infoSet_same_actions : ∀ n₁ n₂, infoSet n₁ n₂ → actionsAt n₁ = actionsAt n₂
  outcome : (Node → Action) → Outcome
  payoff : Player → Outcome → ℝ

/-- A strategy for player i: a deterministic choice at each information set. -/
structure ExtensiveFormGame.Strategy (G : ExtensiveFormGame) (i : G.Player) where
  action : G.Node → G.Action
  mem_actionsAt : ∀ n : G.Node, G.playerAt n = i → action n ∈ G.actionsAt n
  infoSet_consistent : ∀ n₁ n₂ : G.Node, G.infoSet n₁ n₂ → action n₁ = action n₂

/-- A pure strategy for player i is a deterministic strategy specifying a choice
    s_i(H) at each information set H ∈ H_i. This is exactly `Strategy`, which is
    deterministic by construction (as opposed to mixed strategies that randomize). -/
abbrev ExtensiveFormGame.PureStrategy (G : ExtensiveFormGame) (i : G.Player) :=
  G.Strategy i