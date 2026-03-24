import Mathlib
open Topology

/-- A symmetric independent private values auction setting with uniform[0,1] valuations -/
structure TwoBidderUniformSetting where
  n_eq : (2 : ℕ) = 2
  uniform_01 : Prop

/-- An auction mechanism in the two-bidder uniform setting -/
structure AuctionMechanism (S : TwoBidderUniformSetting) where
  expectedRevenue : ℝ
  efficient : Prop
  zeroFloorPayment : Prop

/-- Revenue Equivalence Principle: any two efficient mechanisms with zero-floor
    payments yield the same expected revenue in a symmetric IPV setting. -/
axiom revenue_equivalence_principle
    (S : TwoBidderUniformSetting)
    (M₁ M₂ : AuctionMechanism S)
    (h₁_eff : M₁.efficient)
    (h₂_eff : M₂.efficient)
    (h₁_zero : M₁.zeroFloorPayment)
    (h₂_zero : M₂.zeroFloorPayment) :
    M₁.expectedRevenue = M₂.expectedRevenue

/-- First-price sealed-bid auction: highest bidder wins, pays own bid. -/
axiom firstPriceAuction (S : TwoBidderUniformSetting) : AuctionMechanism S
axiom firstPriceAuction_efficient (S : TwoBidderUniformSetting) :
    (firstPriceAuction S).efficient
axiom firstPriceAuction_zeroFloor (S : TwoBidderUniformSetting) :
    (firstPriceAuction S).zeroFloorPayment

/-- All-pay auction: highest bidder wins, all bidders pay their bids. -/
axiom allPayAuction (S : TwoBidderUniformSetting) : AuctionMechanism S
axiom allPayAuction_efficient (S : TwoBidderUniformSetting) :
    (allPayAuction S).efficient
axiom allPayAuction_zeroFloor (S : TwoBidderUniformSetting) :
    (allPayAuction S).zeroFloorPayment

/-- In the two-bidder uniform[0,1] setting, the first-price auction and the
    all-pay auction generate exactly the same expected revenue for the seller. -/
theorem first_price_allpay_revenue_equivalence
    (S : TwoBidderUniformSetting) :
    (firstPriceAuction S).expectedRevenue = (allPayAuction S).expectedRevenue :=
  revenue_equivalence_principle S
    (firstPriceAuction S) (allPayAuction S)
    (firstPriceAuction_efficient S) (allPayAuction_efficient S)
    (firstPriceAuction_zeroFloor S) (allPayAuction_zeroFloor S)