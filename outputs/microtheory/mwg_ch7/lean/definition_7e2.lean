import Mathlib
open Topology
open BigOperators

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

/-- A behavior strategy for player `i` in an extensive form game (Definition 7.E.2).

A behavior strategy specifies, for every information set H ∈ H_i and every action
a ∈ C(H), a probability μ(a, H) ≥ 0, with ∑_{a ∈ C(H)} μ(a, H) = 1.

Since information sets are modeled as an equivalence relation on nodes, the probability
assignment is given as a function from nodes and actions to ℝ≥0, required to be
consistent across informationally equivalent nodes. -/
structure ExtensiveFormGame.BehaviorStrategy (G : ExtensiveFormGame) (i : G.Player) where
  /-- The probability assigned to action `a` at node `n`: μ(a, H) where H is the
      information set containing n -/
  prob : G.Node → G.Action → ℝ
  /-- Probabilities are nonneg: μ(a, H) ≥ 0 -/
  prob_nonneg : ∀ (n : G.Node) (a : G.Action), 0 ≤ prob n a
  /-- Actions outside C(H) get zero probability -/
  prob_support : ∀ (n : G.Node) (a : G.Action), a ∉ G.actionsAt n → prob n a = 0
  /-- The strategy is consistent on information sets: if n₁ ~ n₂ then μ(·, n₁) = μ(·, n₂) -/
  infoSet_consistent : ∀ (n₁ n₂ : G.Node), G.infoSet n₁ n₂ → ∀ a, prob n₁ a = prob n₂ a