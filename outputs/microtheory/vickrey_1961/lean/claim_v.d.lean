import Mathlib
open Topology

-- We define a concrete type for an auction mechanism, as the theorem is about a specific one.
inductive AuctionMechanismType
| uniformPriceLastBid : AuctionMechanismType

-- We use a namespace to group the properties related to the claim,
-- mirroring the style suggested by the confirmed identifiers.
namespace ClaimProperties

-- Formalizes: "reducing the probability that a bidder's own bid will affect the price"
axiom ReducesProbabilityBidderAffectsPrice (M : AuctionMechanismType) : Prop

-- Formalizes: "inducing bids closer to the full value to the bidder"
axiom InducesBidsCloserToValue (M : AuctionMechanismType) : Prop

-- Formalizes: "improving the chances of obtaining or approaching the optimum allocation"
-- This name is taken from the list of confirmed identifiers.
axiom has_improved_optimum_allocation_chances (M : AuctionMechanismType) : Prop

-- Formalizes: "reducing effort and expense devoted to socially superfluous investigation"
axiom ReducesSuperfluousInvestigation (M : AuctionMechanismType) : Prop

end ClaimProperties

-- We formalize the implications within the claim as axioms.
axiom advantage_implies_truthful_bidding (M : AuctionMechanismType) :
  ClaimProperties.ReducesProbabilityBidderAffectsPrice M → ClaimProperties.InducesBidsCloserToValue M

axiom truthful_bidding_improves_allocation (M : AuctionMechanismType) :
  ClaimProperties.InducesBidsCloserToValue M → ClaimProperties.has_improved_optimum_allocation_chances M

axiom truthful_bidding_reduces_investigation (M : AuctionMechanismType) :
  ClaimProperties.InducesBidsCloserToValue M → ClaimProperties.ReducesSuperfluousInvestigation M

-- The claim starts with the premise that this mechanism has the key advantage.
-- "The analysis indicates that the method... has the more material advantage of..."
axiom uniform_price_has_advantage :
  ClaimProperties.ReducesProbabilityBidderAffectsPrice AuctionMechanismType.uniformPriceLastBid

-- Theorem Claim_V.D:
-- The full claim is that the mechanism leads to both improved allocation and reduced investigation.
theorem Claim_V_D :
  ClaimProperties.has_improved_optimum_allocation_chances AuctionMechanismType.uniformPriceLastBid ∧
  ClaimProperties.ReducesSuperfluousInvestigation AuctionMechanismType.uniformPriceLastBid := by
  -- First, we establish the intermediate consequence: inducing bids closer to value.
  have h_induces_bids : ClaimProperties.InducesBidsCloserToValue AuctionMechanismType.uniformPriceLastBid :=
    advantage_implies_truthful_bidding AuctionMechanismType.uniformPriceLastBid uniform_price_has_advantage
  -- From this intermediate step, we can prove both parts of our goal.
  constructor
  · -- Prove that it improves allocation chances.
    exact truthful_bidding_improves_allocation AuctionMechanismType.uniformPriceLastBid h_induces_bids
  · -- Prove that it reduces superfluous investigation.
    exact truthful_bidding_reduces_investigation AuctionMechanismType.uniformPriceLastBid h_induces_bids