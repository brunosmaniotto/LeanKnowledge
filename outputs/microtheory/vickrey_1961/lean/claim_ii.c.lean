import Mathlib

open Finset Set Real

-- A general type for bidders in an auction
variable (Bidder : Type) [Inhabited Bidder] [DecidableEq Bidder]

-- Structure representing an auction scenario with its outcome
structure Auction_Scenario where
  participating_bidders : Finset Bidder
  -- A function mapping each bidder to their private value for the item
  bidder_values : Bidder → ℝ
  -- Predicate indicating if the auction is an ordinary or progressive type
  is_ordinary_or_progressive : Prop
  -- Predicate indicating if all participating bidders are rational
  all_bidders_are_rational : Prop
  -- The final price at which the item is sold
  final_sale_price : ℝ
  -- The bidder who ultimately wins the item
  winning_bidder : Bidder

namespace Auction_Scenario

-- Helper to get the set of values from participating bidders
def value_set (AS : Auction_Scenario Bidder) : Set ℝ :=
  AS.participating_bidders.image AS.bidder_values

-- Helper to find the sorted distinct values in descending order