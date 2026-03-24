import Mathlib

open MeasureTheory Set
open Topology

/-- The Simplified Asymmetrical Bidding Game (Vickrey 1961).
    Bidder 1 draws v1 from a uniform (rectangular) distribution on [0, 1];
    Bidder 2 has the fixed value v2 = a. -/
structure SimplifiedAsymBiddingGame where
  /-- Bidder 2's fixed valuation -/
  a : ℝ

namespace SimplifiedAsymBiddingGame

/-- Bidder 1's value distribution: Lebesgue measure restricted to [0, 1]
    (the rectangular/uniform distribution on [0, 1]). -/
noncomputable def v1Distribution : Measure ℝ :=
  volume.restrict (Icc (0 : ℝ) 1)

/-- Bidder 2's value is the fixed constant a. -/
def v2 (G : SimplifiedAsymBiddingGame) : ℝ := G.a

end SimplifiedAsymBiddingGame