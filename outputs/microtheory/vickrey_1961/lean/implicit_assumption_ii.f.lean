import Mathlib
open Topology

/-- An auction environment satisfying the implicit assumptions of Section II.F of Vickrey (1961):
    collusion among bidders, side payments, communication, and signaling are all ruled out. -/
structure IndependentBiddingAssumption (n : ℕ) (Bid : Type*) where
  /-- No collusion among bidders is permitted. -/
  no_collusion : Prop
  /-- No side payments between bidders are permitted. -/
  no_side_payments : Prop
  /-- No communication between bidders is permitted. -/
  no_communication : Prop
  /-- No signaling between bidders is permitted. -/
  no_signaling : Prop