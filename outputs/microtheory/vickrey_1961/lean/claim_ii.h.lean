import Mathlib

open MeasureTheory ProbabilityTheory

-- Assume a distribution of valuations for other bidders
variable (n_other_bidders : ℕ)
variable (μ : Measure ℝ) [IsProbabilityMeasure μ]
[BorelSpace ℝ] -- Ensures `MeasurableSet (Set.Iic p)` is available for any p.

/--
The probability of winning the auction when the price is `p`.
This is modeled as the probability that all `n_other_bidders` have valuations
less than or equal to `p`, assuming other bidders bid at their valuation.
-/
def probability_of_winning (p : ℝ) : ℝ :=
  (μ (Set.Iic p)).toReal ^ n_other_bidders