import Mathlib
open Topology

-- To capture the statement "is a game", we define a typeclass `IsGame`.
-- A system `S` is a game if it has players, actions, and payoffs.
-- `Players` is an `outParam` so it can be inferred from the system.
class IsGame (S : Type) (Players : outParam (Type)) where
  Actions : Players → Type
  Payoff : S → (Π i : Players, Actions i) → Players → ℝ

-- A Dutch Auction system is defined by its bidders and their valuations.
-- We assume a finite, non-empty set of bidders to ensure a winner can be determined,
-- and decidable equality for comparisons.
structure DutchAuction (Bidders : Type) [Fintype Bidders] [Nonempty Bidders] [DecidableEq Bidders] where
  valuation : Bidders → ℝ

-- The analysis of a Dutch auction shows it is strategically equivalent to a first-price
-- sealed-bid auction. The outcome is that the highest bidder wins. We axiomize a function
-- `get_winner` that returns the winning player from a set of bids. This simplifies the
-- proof by abstracting away tie-breaking rules and the mechanism of finding the max bid.
-- This axiom is marked `noncomputable` because its implementation is not provided and it
-- depends on potentially non-computable properties (like finding a maximum in a set).
noncomputable axiom get_winner {Bidders : Type} [Fintype Bidders] [Nonempty Bidders] [DecidableEq Bidders] (bids : Bidders → ℝ) : Bidders

-- Theorem (Claim_II.E): The analysis of a Dutch auction reveals that it is essentially a 'game' in the technical sense.
-- This theorem asserts the existence of an `IsGame` instance for any `DutchAuction`.
theorem Claim_II_E {Bidders : Type} [Fintype Bidders] [Nonempty Bidders] [DecidableEq Bidders] : Nonempty (IsGame (DutchAuction Bidders) Bidders) := by
  -- We explicitly construct the `IsGame` instance for `DutchAuction Bidders`.
  -- This bypasses the need for `infer_instance` to find a `noncomputable instance`
  -- and directly provides the required term for `Nonempty.intro`.
  apply Nonempty.intro
  exact {
    Actions := fun (_p : Bidders) => ℝ, -- Each player's action is to submit a real-valued bid.
    Payoff := fun (auction : DutchAuction Bidders) (bids : Π i : Bidders, ℝ) (player : Bidders) =>
      let winner := get_winner bids -- Determine the winner based on the bids.
      let price := bids winner      -- The price paid by the winner is their own bid.
      if player = winner then
        auction.valuation player - price -- Winner's payoff is valuation minus price.
      else
        0 -- Losers get zero payoff.
  }