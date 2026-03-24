import Mathlib
open Topology

-- Define basic entities relevant to the claim.
-- `deriving Inhabited` is included for general utility, allowing for arbitrary instances if needed elsewhere.
structure Seller where
  name : String
deriving Inhabited

structure Bidder where
  name : String
deriving Inhabited

structure TermsOfSale where
  details : String
deriving Inhabited

-- Define the elementary predicates as axioms.
-- These axioms represent the fundamental, unproven assertions or atomic facts
-- directly derived from the natural language claim.
axiom IsGovernmentalBody (s : Seller) : Prop
axiom IsLargeCorporation (s : Seller) : Prop
axiom PublishesTerms (s : Seller) (terms : TermsOfSale) : Prop
axiom IsImproperlyOverlooked (b : Bidder) (terms : TermsOfSale) : Prop
axiom IsTopBidder (b : Bidder) (terms : TermsOfSale) : Prop
axiom IsOnNotice (b : Bidder) : Prop
axiom HasIndirectInterestInProtest (b : Bidder) : Prop

-- These axioms formalize the direct logical consequences stated in the claim.
-- They capture the "if ... then ..." relationships that are not derivable
-- from more basic mathematical principles within Mathlib, but are asserted
-- as true in the context of this specific claim.

/--
Axiom: If a seller (governmental/large corp) publishes terms, and a bidder is improperly overlooked,
then that bidder is on notice.
-/
axiom overlooks_implies_on_notice (s : Seller) (terms : TermsOfSale) (b : Bidder) :
  (IsGovernmentalBody s ∨ IsLargeCorporation s) →
  PublishesTerms s terms →
  IsImproperlyOverlooked b terms →
  IsOnNotice b

/--
Axiom: If a seller (governmental/large corp) publishes terms, a bidder is improperly overlooked,
and that bidder is not the top bidder, then they have an indirect interest in lodging a protest.
-/
axiom not_top_bidder_implies_indirect_interest (s : Seller) (terms : TermsOfSale) (b : Bidder) :
  (IsGovernmentalBody s ∨ IsLargeCorporation s) →
  PublishesTerms s terms →
  IsImproperlyOverlooked b terms →
  ¬ IsTopBidder b terms →
  HasIndirectInterestInProtest b

/--
Theorem (Claim_III.O):
Where the seller is a governmental body or a large corporation, it would be desirable to publish the final terms of sale;
if this is done, any bidder whose bid has been improperly overlooked would at least be on notice of this,
though, unless they were actually the top bidder, they would have only an indirect interest in lodging a protest.
-/
theorem Claim_III_O :
  ∀ (s : Seller) (terms : TermsOfSale) (b : Bidder),
    (IsGovernmentalBody s ∨ IsLargeCorporation s) →
    PublishesTerms s terms →
    ((IsImproperlyOverlooked b terms → IsOnNotice b) ∧
     (IsImproperlyOverlooked b terms ∧ ¬ IsTopBidder b terms → HasIndirectInterestInProtest b)) :=
  by
    -- Introduce universal quantifiers and the two main hypotheses from the claim.
    intros s terms b h_seller_type h_published_terms

    -- The goal is a conjunction of two implications. We prove each part separately using `And.intro`.
    apply And.intro

    -- Prove the first implication: `IsImproperlyOverlooked b terms → IsOnNotice b`
    . intro h_overlooked
      -- This directly follows from the `overlooks_implies_on_notice` axiom.
      exact overlooks_implies_on_notice s terms b h_seller_type h_published_terms h_overlooked

    -- Prove the second implication: `IsImproperlyOverlooked b terms ∧ ¬ IsTopBidder b terms → HasIndirectInterestInProtest b`
    . intro h_overlooked_and_not_top
      -- Deconstruct the conjunctive hypothesis `h_overlooked_and_not_top` into its two parts.
      rcases h_overlooked_and_not_top with ⟨h_overlooked, h_not_top⟩
      -- This directly follows from the `not_top_bidder_implies_indirect_interest` axiom.
      exact not_top_bidder_implies_indirect_interest s terms b h_seller_type h_published_terms h_overlooked h_not_top