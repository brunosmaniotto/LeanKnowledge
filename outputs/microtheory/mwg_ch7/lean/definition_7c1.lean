import Mathlib
open Topology

/-- The extensive form representation of a game.
Captures who moves when, what actions each player can take,
what players know when they move, what the outcome is as a function
of the actions taken, and the players' payoffs from each possible outcome. -/
structure ExtensiveFormGame where
  /-- The set of players -/
  Player : Type*
  /-- The set of decision nodes (who moves when) -/
  Node : Type*
  /-- The set of possible actions -/
  Action : Type*
  /-- The set of possible outcomes -/
  Outcome : Type*
  /-- Assignment of each decision node to the player who moves there -/
  playerAt : Node → Player
  /-- The set of available actions at each decision node -/
  actionsAt : Node → Set Action
  /-- Information sets: nodes that are indistinguishable to the player moving there.
      Two nodes in the same information set means the player cannot tell them apart. -/
  infoSet : Node → Node → Prop
  /-- Information set equivalence is reflexive -/
  infoSet_refl : ∀ n, infoSet n n
  /-- Information set equivalence is symmetric -/
  infoSet_symm : ∀ n₁ n₂, infoSet n₁ n₂ → infoSet n₂ n₁
  /-- Information set equivalence is transitive -/
  infoSet_trans : ∀ n₁ n₂ n₃, infoSet n₁ n₂ → infoSet n₂ n₃ → infoSet n₁ n₃
  /-- Nodes in the same information set belong to the same player -/
  infoSet_same_player : ∀ n₁ n₂, infoSet n₁ n₂ → playerAt n₁ = playerAt n₂
  /-- Nodes in the same information set have the same available actions -/
  infoSet_same_actions : ∀ n₁ n₂, infoSet n₁ n₂ → actionsAt n₁ = actionsAt n₂
  /-- The outcome function: maps a history of actions to an outcome -/
  outcome : (Node → Action) → Outcome
  /-- Each player's payoff from each possible outcome -/
  payoff : Player → Outcome → ℝ

/-- A game is one of perfect information if each information set contains
a single decision node; that is, no two distinct nodes are informationally
indistinguishable. Otherwise, it is a game of imperfect information. -/
def ExtensiveFormGame.isPerfectInformation (G : ExtensiveFormGame) : Prop :=
  ∀ n₁ n₂ : G.Node, G.infoSet n₁ n₂ → n₁ = n₂