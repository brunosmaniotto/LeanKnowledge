import Mathlib
open Topology

-- An inductive type to represent the method of announcement
inductive AnnouncementMethod
| top_bid        -- The top bid is announced
| effective_price -- Only the effective price is announced

/--
Claim_III.P: If a bidder is uncertain of the amount of the successful bid and their protest
is motivated by a hope of being the top bidder, there would be some advantage in not
announcing the top bid, but only the effective price.
-/
def Claim_III.P {Bidder : Type*} {BidAmount : Type*} [PartialOrder BidAmount]
    (is_uncertain : Bidder → BidAmount → Prop)
    (protest_motivated_by_hope_of_top_bidder : Bidder → Prop)
    (has_advantage : Bidder → AnnouncementMethod → Prop) : Prop :=
  -- For any bidder `b`
  ∀ (b : Bidder),
    -- If `b` is uncertain about some successful bid amount `s`
    (∃ (s : BidAmount), is_uncertain b s) ∧
    -- AND `b`'s protest is motivated by the hope of being the top bidder
    protest_motivated_by_hope_of_top_bidder b →
    -- THEN `b` would have some advantage in not announcing the top bid, but only the effective price.
    has_advantage b AnnouncementMethod.effective_price ∧ ¬ has_advantage b AnnouncementMethod.top_bid