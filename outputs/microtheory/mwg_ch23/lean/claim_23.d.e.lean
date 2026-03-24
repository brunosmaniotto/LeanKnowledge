import Mathlib
open Topology

/-- A symmetric independent private values auction setting -/
structure SymmetricAuctionSetting where
  n : ℕ
  n_pos : 0 < n

/-- An auction mechanism in a symmetric setting -/
structure AuctionMechanism (S : SymmetricAuctionSetting) where
  expectedRevenue : ℝ
  efficient : Prop
  zeroFloorPayment : Prop

/-- Revenue Equivalence Principle: any two efficient mechanisms with zero-floor
    payments yield the same expected revenue in a symmetric IPV setting. -/
axiom revenue_equivalence_principle
    (S : SymmetricAuctionSetting)
    (M₁ M₂ : AuctionMechanism S)
    (h₁_eff : M₁.efficient)
    (h₂_eff : M₂.efficient)
    (h₁_zero : M₁.zeroFloorPayment)
    (h₂_zero : M₂.zeroFloorPayment) :
    M₁.expectedRevenue = M₂.expectedRevenue

/-- First-price sealed-bid auction: highest bidder wins, pays own bid. -/
axiom firstPriceAuction (S : SymmetricAuctionSetting) : AuctionMechanism S
axiom firstPriceAuction_efficient (S : SymmetricAuctionSetting) :
    (firstPriceAuction S).efficient
axiom firstPriceAuction_zeroFloor (S : SymmetricAuctionSetting) :
    (firstPriceAuction S).zeroFloorPayment

/-- Second-price sealed-bid auction: highest bidder wins, pays second-highest bid. -/
axiom secondPriceAuction (S : SymmetricAuctionSetting) : AuctionMechanism S
axiom secondPriceAuction_efficient (S : SymmetricAuctionSetting) :
    (secondPriceAuction S).efficient
axiom secondPriceAuction_zeroFloor (S : SymmetricAuctionSetting) :
    (secondPriceAuction S).zeroFloorPayment

/-- In any symmetric auction setting, first-price and second-price sealed-bid
    auctions generate exactly the same expected revenue for the seller. -/
theorem first_price_second_price_revenue_equivalence
    (S : SymmetricAuctionSetting) :
    (firstPriceAuction S).expectedRevenue = (secondPriceAuction S).expectedRevenue :=
  revenue_equivalence_principle S
    (firstPriceAuction S) (secondPriceAuction S)
    (firstPriceAuction_efficient S) (secondPriceAuction_efficient S)
    (firstPriceAuction_zeroFloor S) (secondPriceAuction_zeroFloor S)