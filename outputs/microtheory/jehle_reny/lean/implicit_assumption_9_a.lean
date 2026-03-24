import Mathlib

open MeasureTheory ProbabilityTheory

/-- In all auctions considered, ties in bids are broken at random:
    each tied bidder is equally likely to be deemed the winner.
    This structure encapsulates a tie-breaking rule satisfying the
    uniform randomness assumption. -/
structure UniformTieBreaking (ι : Type*) [DecidableEq ι] where
  /-- Given a nonempty finite set of tied bidders, return the probability
      that each bidder is selected as the winner. -/
  winProb : Finset ι → ι → ℝ
  /-- The probability is uniform: each tied bidder gets equal probability 1/|tied|. -/
  uniform : ∀ (S : Finset ι), S.Nonempty →
    ∀ i ∈ S, winProb S i = 1 / (S.card : ℝ)
  /-- Non-tied bidders get zero probability. -/
  outside : ∀ (S : Finset ι) (i : ι), i ∉ S → winProb S i = 0