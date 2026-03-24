import Mathlib

open MeasureTheory ProbabilityTheory
open Topology

/-- A homogeneous rectangular single-prize bidding problem:
    N players each draw a value from Uniform[0,1] and submit a bid for a single prize. -/
structure HomogeneousRectangularSinglePrizeBidding where
  /-- Number of players (at least 1) -/
  numPlayers : ℕ
  numPlayers_pos : 0 < numPlayers
  /-- Each player's value is drawn from the uniform distribution on [0,1] -/
  value : Fin numPlayers → ℝ
  value_mem : ∀ i, 0 ≤ value i ∧ value i ≤ 1
  /-- Each player's bid -/
  bid : Fin numPlayers → ℝ
  bid_nonneg : ∀ i, 0 ≤ bid i