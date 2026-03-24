import Mathlib
open Topology

/-- An exclusive public marketing agency for a commodity market.
All sales of the commodity must be made to the agency (exclusive buyer),
and all supplies of the commodity must be bought from the agency (exclusive seller). -/
structure ExclusivePublicMarketingAgency (Agent : Type*) where
  /-- The agency entity -/
  agency : Agent
  /-- Predicate: `sellsTo s b` means agent `s` sells the commodity to agent `b` -/
  sellsTo : Agent → Agent → Prop
  /-- Predicate: `buysFrom b s` means agent `b` buys the commodity from agent `s` -/
  buysFrom : Agent → Agent → Prop
  /-- All sales of the commodity must be made to the agency -/
  exclusive_buyer : ∀ s b, sellsTo s b → b = agency
  /-- All supplies of the commodity must be bought from the agency -/
  exclusive_seller : ∀ b s, buysFrom b s → s = agency