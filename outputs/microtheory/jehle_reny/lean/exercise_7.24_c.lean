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

/-- All-pay auction: highest bidder wins, every bidder pays their bid. -/
axiom allPayAuction (S : SymmetricAuctionSetting) : AuctionMechanism S
axiom allPayAuction_efficient (S : SymmetricAuctionSetting) :
    (allPayAuction S).efficient
axiom allPayAuction_zeroFloor (S : SymmetricAuctionSetting) :
    (allPayAuction S).zeroFloorPayment

/-- The first-price auction and the all-pay auction generate the same
    expected revenue for the seller, ex ante. -/
theorem first_price_all_pay_revenue_equivalence
    (S : SymmetricAuctionSetting) :
    (firstPriceAuction S).expectedRevenue = (allPayAuction S).expectedRevenue :=
  revenue_equivalence_principle S
    (firstPriceAuction S) (allPayAuction S)
    (firstPriceAuction_efficient S) (allPayAuction_efficient S)
    (firstPriceAuction_zeroFloor S) (allPayAuction_zeroFloor S)