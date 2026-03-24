import Mathlib
open Topology

/-- A Dutch (descending-price) auction for a single object.
    The auctioneer starts at a high asking price and reduces it continuously.
    The first bidder to accept the current price wins the object at that price. -/
structure DutchAuction (n : ℕ) where
  /-- Initial asking price (set very high) -/
  startPrice : ℝ
  /-- Descending price as a function of time -/
  priceClock : ℝ → ℝ
  /-- Each bidder's acceptance time; `none` if they never accept -/
  acceptTime : Fin n → Option ℝ
  /-- Starting price is positive -/
  startPrice_pos : 0 < startPrice
  /-- Clock begins at the starting price -/
  clock_init : priceClock 0 = startPrice
  /-- Clock is strictly decreasing (price falls over time) -/
  clock_strictAnti : StrictAnti priceClock