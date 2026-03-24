import Mathlib

structure ZeroSumGame (S₁ S₂ : Type*) where
  payoff : S₁ → S₂ → ℝ

def ZeroSumGame.IsNE (G : ZeroSumGame S₁ S₂) (s₁ : S₁) (s₂ : S₂) : Prop :=
  (∀ t₁ : S₁, G.payoff t₁ s₂ ≤ G.payoff s₁ s₂) ∧
  (∀ t₂ : S₂, G.payoff s₁ s₂ ≤ G.payoff s₁ t₂)