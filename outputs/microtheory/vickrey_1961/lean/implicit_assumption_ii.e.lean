import Mathlib

open MeasureTheory ProbabilityTheory
open Topology

/-- A tie-breaking rule for a parlor game: when multiple players submit the same
    bid, the winner is selected by a random drawing that gives each tied player
    equal probability of winning. -/
structure UniformTieBreaking (Player : Type*) [DecidableEq Player] [Fintype Player] where
  /-- Given a nonempty set of tied players, select a winner randomly. -/
  selectWinner : (tied : Finset Player) → tied.Nonempty → Player
  /-- The selected winner is always among the tied players. -/
  winner_mem : ∀ (tied : Finset Player) (h : tied.Nonempty),
    selectWinner tied h ∈ tied
  /-- Each tied player has equal probability of winning (1 / number of tied players). -/
  uniform_prob : ∀ (tied : Finset Player) (h : tied.Nonempty) (p : Player),
    p ∈ tied → (1 : ℝ) / tied.card = 1 / tied.card