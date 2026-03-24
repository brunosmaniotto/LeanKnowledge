import Mathlib
open Topology

-- We formalize the economic claim by defining a model with abstract functions
-- and then proving the relationship between the concepts.

-- Let n be the number of firms in the market.
variable (n : ℕ)

-- We model the market using functions from the number of firms to real-valued outcomes.
-- `π_firm n`: profit per firm. We assume firms are symmetric.
-- `CS n`: consumer surplus.
variable (π_firm CS : ℕ → ℝ)

-- Total industry profit is the number of firms times the profit per firm.
def π_total (n : ℕ) : ℝ := n * π_firm n

-- Social welfare is the sum of consumer surplus and total producer profit.