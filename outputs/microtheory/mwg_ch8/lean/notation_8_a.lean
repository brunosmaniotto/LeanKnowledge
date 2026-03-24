import Mathlib
open scoped symmDiff
open Topology

/-- A normal form game with pure strategies: Γ_N = [I, {S_i}, {u_i(·)}]. -/
structure NormalFormGame where
  /-- The type of players. -/
  I : Type*
  /-- The pure strategy set for each player. -/
  S : I → Type*
  /-- The payoff function for each player, given a strategy profile. -/
  u : I → (∀ i, S i) → ℝ

/-- A normal form game with mixed strategies: Γ_N = [I, {Δ(S_i)}, {u_i(·)}].
    Δ(S_i) is represented by `PMF (S i)`, the set of probability mass functions
    over player i's pure strategy set. -/
structure MixedNormalFormGame where
  /-- The type of players. -/
  I : Type*
  /-- The pure strategy set for each player (must be finite and measurable). -/
  S : I → Type*
  /-- The payoff function for each player, given a mixed strategy profile. -/
  u : I → (∀ i, PMF (S i)) → ℝ