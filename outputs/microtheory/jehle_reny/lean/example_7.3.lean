import Mathlib
open Finset BigOperators Nat
open Topology

noncomputable section

-- Define market demand function
def market_demand (p : ℝ) : ℝ := 8 - p

-- Define quantity sold for firm i given its price p_i and competitor's price p_j