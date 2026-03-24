import Mathlib

open MeasureTheory
open Topology

/-- Common prior assumption (Vickrey 1961, §II.C): all bidders share the same
    belief about the probability distribution from which any given player's
    valuation is drawn. -/
structure CommonPrior (N : Type*) (V : Type*) [MeasurableSpace V] where
  /-- Bidder `i`'s belief about bidder `j`'s value distribution -/
  belief : N → N → Measure V
  /-- Each belief is a probability measure -/
  isProbability : ∀ i j, IsProbabilityMeasure (belief i j)
  /-- All bidders agree on the distribution for any given player -/
  common : ∀ i₁ i₂ j, belief i₁ j = belief i₂ j