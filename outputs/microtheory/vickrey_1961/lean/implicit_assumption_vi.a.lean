import Mathlib
open Topology

/-- Vickrey's Implicit Assumption VI.A: the model imputes a high degree of
    rationality and sophistication to all bidders. -/
structure RationalBidderAssumption (Bidder : Type*) where
  /-- Predicate: a bidder is rational -/
  isRational : Bidder → Prop
  /-- Predicate: a bidder is sophisticated -/
  isSophisticated : Bidder → Prop
  /-- Every bidder is rational -/
  rational_all : ∀ b, isRational b
  /-- Every bidder is sophisticated -/
  sophisticated_all : ∀ b, isSophisticated b