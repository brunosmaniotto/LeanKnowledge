import Mathlib

universe u v

-- We define a structure to represent the two-stage duopoly model
-- with strategic precommitment.
structure TwoStageDuopoly (S₁ : Type u) (S₂ : Type v) where
  -- Stage 1: Firm 1 invests at an observable level k.
  k : ℝ

  -- Stage 2: Firms 1 and 2 play an oligopoly game.
  -- Profit functions for Firm 1 and Firm 2.
  π₁ : S₁ → S₂ → ℝ → ℝ
  π₂ : S₁ → S₂ → ℝ → ℝ

  -- There is a unique Nash equilibrium (s₁*(k), s₂*(k)) in stage 2 given k.
  s₁_star : ℝ → S₁
  s₂_star : ℝ → S₂

  -- The pair (s₁_star k, s₂_star k) is a Nash Equilibrium.
  is_nash_equilibrium : ∀ k' : ℝ,
    let s₁' := s₁_star k'
    let s₂' := s₂_star k'
    (∀ s₁ : S₁, π₁ s₁ s₂' k' ≤ π₁ s₁' s₂' k') ∧
    (∀ s₂ : S₂, π₂ s₁' s₂ k' ≤ π₂ s₁' s₂' k')

  -- The Nash Equilibrium is unique.
  unique_nash_equilibrium : ∀ k' : ℝ, ∀ s₁' : S₁, ∀ s₂' : S₂,
    ((∀ s₁ : S₁, π₁ s₁ s₂' k' ≤ π₁ s₁' s₂' k') ∧
     (∀ s₂ : S₂, π₂ s₁' s₂ k' ≤ π₂ s₁' s₂' k')) →
    s₁' = s₁_star k' ∧ s₂' = s₂_star k'

  -- Assumption: Actions are 'aggressive'.
  -- This is a placeholder for the condition ∂π_j/∂s_{-j} < 0.
  -- A full formalization would require more context on the structure of S₁ and S₂.
  profits_are_aggressive : Prop