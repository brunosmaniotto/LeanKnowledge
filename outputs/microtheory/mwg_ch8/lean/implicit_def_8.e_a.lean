import Mathlib
open Topology

/-- A game of complete information is one in which players know all relevant
information about each other, including the payoffs that each receives
from the various outcomes of the game. -/
structure CompleteInformationGame where
  /-- The type of players -/
  Player : Type*
  /-- The type of strategy profiles (one strategy per player) -/
  Strategy : Player → Type*
  /-- The type of outcomes -/
  Outcome : Type*
  /-- The outcome function mapping strategy profiles to outcomes -/
  outcome : (∀ i, Strategy i) → Outcome
  /-- Each player's payoff from each outcome -/
  payoff : Player → Outcome → ℝ
  /-- Players is finite -/
  [finPlayer : Fintype Player]
  /-- Each strategy set is finite -/
  [finStrategy : ∀ i, Fintype (Strategy i)]
  /-- Each strategy set is decidable eq -/
  [decStrategy : ∀ i, DecidableEq (Strategy i)]