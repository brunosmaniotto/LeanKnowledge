import Mathlib

open MeasureTheory ProbabilityTheory
open Topology

/-- Tractability assumption for the Dutch auction (Vickrey 1961, Assumption II.B):
    each bidder's knowledge about others' motives and probable behavior is derived
    from a set of probability distributions from which the value of the object
    to each bidder is conceived to be drawn. -/
structure DutchAuctionTractability (n : ℕ) where
  /-- Common probability space -/
  Ω : Type*
  instMeasurable : MeasurableSpace Ω
  μ : Measure Ω
  instProb : IsProbabilityMeasure μ
  /-- Value random variable for each bidder -/
  value : Fin n → Ω → ℝ
  /-- Each bidder's value is a measurable function -/
  value_measurable : ∀ i, Measurable (value i)