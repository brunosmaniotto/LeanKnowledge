import Mathlib
open Topology

/-- A two-player zero-sum game: a game of pure conflict where one player's gain
    is exactly the other player's loss. -/
structure ZeroSumGame (S₁ S₂ : Type*) where
  /-- Payoff to Player 1 given strategy choices of both players -/
  payoff₁ : S₁ → S₂ → ℝ
  /-- Payoff to Player 2 given strategy choices of both players -/
  payoff₂ : S₁ → S₂ → ℝ
  /-- Zero-sum property: what one player wins, the other loses -/
  zero_sum : ∀ (s₁ : S₁) (s₂ : S₂), payoff₁ s₁ s₂ + payoff₂ s₁ s₂ = 0