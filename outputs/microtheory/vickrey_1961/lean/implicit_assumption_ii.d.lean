import Mathlib

open MeasureTheory
open Topology

/-- A player's knowledge in a private-value auction (Vickrey 1961, Assumption II.D):
    each player knows their own valuation and the probability distribution from which
    other players consider that valuation to be drawn. -/
structure PrivateValueKnowledge (ι : Type*) where
  /-- The actual value each player places on the object. -/
  valuation : ι → ℝ
  /-- The distribution from which others consider player i's value to be drawn. -/
  perceivedDist : ι → Measure ℝ
  /-- Each perceived distribution is a probability measure. -/
  isProbability : ∀ i, IsProbabilityMeasure (perceivedDist i)