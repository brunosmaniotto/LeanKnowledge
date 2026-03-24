import Mathlib
open Topology

/-- A perfectly competitive market (Definition 4.1).
    A market in which buyers and sellers are sufficiently numerous that
    no single agent can influence the market price — all are price takers. -/
structure PerfectlyCompetitiveMarket where
  /-- The type of buyers in the market -/
  Buyer : Type*
  /-- The type of sellers in the market -/
  Seller : Type*
  /-- Buyers form a finite type -/
  [buyerFintype : Fintype Buyer]
  /-- Sellers form a finite type -/
  [sellerFintype : Fintype Seller]
  /-- The market has many buyers (no single buyer dominates) -/
  buyers_large : Fintype.card Buyer ≥ 2
  /-- The market has many sellers (no single seller dominates) -/
  sellers_large : Fintype.card Seller ≥ 2
  /-- The market price, taken as given by all participants -/
  marketPrice : ℝ
  /-- Each buyer is a price taker: their individual demand does not affect the price.
      Modeled as: buyer's perceived price equals the market price. -/
  buyer_price_taker : Buyer → ℝ
  /-- All buyers perceive the market price -/
  buyer_takes_price : ∀ b, buyer_price_taker b = marketPrice
  /-- Each seller is a price taker: their individual supply does not affect the price. -/
  seller_price_taker : Seller → ℝ
  /-- All sellers perceive the market price -/
  seller_takes_price : ∀ s, seller_price_taker s = marketPrice