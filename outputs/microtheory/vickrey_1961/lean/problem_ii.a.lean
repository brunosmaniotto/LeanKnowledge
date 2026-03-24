import Mathlib
open MeasureTheory ProbabilityTheory
open Topology

-- Abstract types for the core components of an auction problem
variable (Bidder : Type)          -- The type representing individual bidders (e.g., `Fin N`)
variable (PrivateInfo : Type)     -- The type for a bidder's private information (e.g., `ℝ` for a valuation)
variable (Bid : Type)             -- The type for a bid (e.g., `ℝ`)

-- A `BiddingStrategy` is a function that maps a bidder's private information to their chosen bid.
def BiddingStrategy : Type := PrivateInfo → Bid

-- A `StrategyProfile` is a collection of strategies, one for each bidder.