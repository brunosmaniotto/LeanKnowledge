import Mathlib
open Topology

/-- A Bayesian game (game of incomplete information) in the sense of Harsanyi (1967-68).
    Each player i has a type θ_i drawn by nature from a joint distribution F,
    and a payoff function u_i(s_i, s_{-i}, θ_i). -/
structure BayesianGame where
  /-- Number of players -/
  I : ℕ
  /-- Strategy set for each player -/
  S : Fin I → Type
  /-- Type set for each player (possible types chosen by nature) -/
  Θ : Fin I → Type
  /-- Payoff function for player i, given: player i's strategy, all players' strategies, and player i's type -/
  u : (i : Fin I) → S i → ((j : Fin I) → S j) → Θ i → ℝ
  /-- Joint probability distribution over the product type space Θ_1 × ··· × Θ_I,
      represented as a probability mass function on type profiles -/
  F : ((i : Fin I) → Θ i) → ℝ
  /-- F assigns nonneg probabilities -/
  F_nonneg : ∀ θ, 0 ≤ F θ