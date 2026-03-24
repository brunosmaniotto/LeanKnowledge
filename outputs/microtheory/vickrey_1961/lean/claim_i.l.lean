import Mathlib

open BigOperators Finset
open Topology

-- Let d(i) be the value of the i-th unit to a purchaser (demand curve).
-- Let s(i) be the cost of the i-th unit for a supplier (supply curve).

-- In the marketing agency scheme, the agency pays suppliers the full value
-- that purchasers place on each unit.
def aggregate_payments (n : ℕ) (d : ℕ → ℝ) : ℝ :=
  ∑ i ∈ range n, d i

-- The agency charges purchasers only the cost that suppliers incur for each unit.