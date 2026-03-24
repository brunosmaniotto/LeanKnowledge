import Mathlib
open Topology

/-- A Nash equilibrium for a Dutch auction game with `n` players.

Each player `i` has a strategy function `xᵢ : ℝ → ℝ` mapping their private value `vᵢ`
to a bid `xᵢ(vᵢ)`. The profile is an equilibrium when no player can unilaterally change
their strategy to increase their expected gain, given the other players' strategies are fixed.

The `expectedGain` parameter abstracts over the auction mechanics and value distributions:
given a full strategy profile and a player index, it returns that player's expected payoff. -/
structure DutchAuctionNashEquilibrium (n : ℕ)
    (expectedGain : (Fin n → (ℝ → ℝ)) → Fin n → ℝ) where
  /-- Strategy profile: for each player, a function from private value to bid. -/
  strategies : Fin n → (ℝ → ℝ)
  /-- No player can unilaterally deviate to improve their expected gain. -/
  no_profitable_deviation : ∀ (i : Fin n) (xi' : ℝ → ℝ),
    expectedGain strategies i ≥ expectedGain (Function.update strategies i xi') i