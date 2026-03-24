import Mathlib

/-- A Dutch auction over a type of bidders and a price type.
The auctioneer announces prices in descending order, and the first bid
placed concludes the transaction. -/
structure DutchAuction (Bidder : Type*) (Price : Type*) [LinearOrder Price] where
  /-- The descending sequence of prices announced by the auctioneer. -/
  price_sequence : ℕ → Price
  /-- The price sequence is strictly descending. -/
  descending : StrictAnti price_sequence
  /-- The round at which the (unique) winning bid is placed. -/
  winning_round : ℕ
  /-- The bidder who places the winning bid. -/
  winner : Bidder
  /-- The transaction price is the price announced at the winning round. -/
  transaction_price : Price := price_sequence winning_round