import Mathlib

-- Define the elementary propositions
variable (bidderSingleUnitInterest : Prop)
variable (bidderNoCollusion : Prop)

-- Define what it means for "first-rejected-bid" pricing to apply
def firstRejectedBidPricingApplies := bidderSingleUnitInterest ∧ bidderNoCollusion