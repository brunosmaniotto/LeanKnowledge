import Mathlib

/-
  A context for our economic model, containing bidders and their valuations.
  This setup allows for "non-homogeneous cases" by having an arbitrary valuation function.
-/
structure MarketingAgencyScheme where
  Bidder : Type
  [fintype : Fintype Bidder]
  [nonempty : Nonempty Bidder]
  valuation : Bidder → ℝ

/-
  An allocation mechanism selects a winner from a scheme.
  This represents the outcome of the auction process.
  The mechanism is a dependent function, returning a bidder of the specific scheme.
-/
variable (mechanism : (scheme : MarketingAgencyScheme) → scheme.Bidder)

/-
  A progressive auction is defined as one that selects a bidder who maximizes valuation.
  The `mechanism'` parameter is used to avoid shadowing the `mechanism` variable.
-/
def IsProgressiveAuction (mechanism' : (scheme : MarketingAgencyScheme) → scheme.Bidder) : Prop :=
  ∀ (scheme : MarketingAgencyScheme),
    let winner := mechanism' scheme
    ∀ (b : scheme.Bidder), scheme.valuation b ≤ scheme.valuation winner

/-
  An allocation is defined as optimal if the winner has the highest valuation.
-/