import Mathlib
open Topology

/-- In the simplified non-homogeneous case, the second bidder's value is fixed at `a`
    rather than drawn from a range `[a, b]`. -/
structure FixedSecondBidderValue (α : Type*) [LinearOrder α] where
  /-- The fixed value for the second bidder -/
  a : α
  /-- The value assigned to the second bidder -/
  secondBidderValue : α
  /-- The second bidder's value is fixed at `a` -/
  value_eq : secondBidderValue = a