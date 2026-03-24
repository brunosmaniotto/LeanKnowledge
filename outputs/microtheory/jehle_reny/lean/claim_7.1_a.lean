import Mathlib
open Topology
open Classical -- For decidability of propositions like `¬P`

/-- A two-player zero-sum game: a game of pure conflict where one player's gain
    is exactly the other player's loss. -/
structure ZeroSumGame (S₁ S₂ : Type*) where
  payoff : S₁ → S₂ → ℝ

def ZeroSumGame.IsNE (G : ZeroSumGame S₁ S₂) (s₁ : S₁) (s₂ : S₂) : Prop :=
  (∀ t₁ : S₁, G.payoff t₁ s₂ ≤ G.payoff s₁ s₂) ∧ (∀ t₂ : S₂, G.payoff s₁ t₂ ≥ G.payoff s₁ s₂)

-- The type `Fin 2` represents the two strategies (0 and 1) for each player.