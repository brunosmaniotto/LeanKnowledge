import Mathlib
open Topology

/-- A game of incomplete information (Bayesian game) where players may not know
    all relevant information about each other. Each player has a type representing
    their private information, and payoffs depend on the full type profile. -/
structure BayesianGame where
  /-- The type of players -/
  Player : Type
  /-- Each player has a set of possible types (private information) -/
  TypeSpace : Player → Type
  /-- Each player has a set of available actions -/
  Action : Player → Type
  /-- Prior probability distribution over type profiles.
      Given a full type profile (assignment of types to all players),
      returns the probability of that profile. -/
  prior : (∀ i, TypeSpace i) → ℝ
  /-- Utility function: given an action profile and type profile,
      returns each player's payoff -/
  utility : Player → (∀ i, Action i) → (∀ i, TypeSpace i) → ℝ
  /-- The prior assigns nonneg probabilities -/
  prior_nonneg : ∀ t, 0 ≤ prior t