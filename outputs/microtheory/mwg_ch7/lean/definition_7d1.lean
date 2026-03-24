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

/-- A strategy for player `i` in an extensive form game (Definition 7.D.1).

A strategy is a function `s_i : H_i → A` assigning an action to each of player i's
information sets, such that `s_i(H) ∈ C(H)` for all H ∈ H_i. Since information sets
are modeled as an equivalence relation on nodes, a strategy is a function from nodes
to actions that (1) always picks an available action and (2) assigns the same action
to informationally equivalent nodes. -/
structure ExtensiveFormGame.Strategy (G : ExtensiveFormGame) (i : G.Player) where
  /-- The action chosen at each node belonging to player i -/
  action : G.Node → G.Action
  /-- The chosen action is available at the node: s_i(H) ∈ C(H) -/
  mem_actionsAt : ∀ n : G.Node, G.playerAt n = i → action n ∈ G.actionsAt n
  /-- The strategy is constant on information sets: if n₁ ~ n₂ then s(n₁) = s(n₂) -/
  infoSet_consistent : ∀ n₁ n₂ : G.Node, G.infoSet n₁ n₂ → action n₁ = action n₂