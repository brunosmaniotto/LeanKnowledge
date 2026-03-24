import Mathlib

open scoped BigOperators
open Finset
open Topology

-- Dimension of the goods space
variable {n : ℕ}
-- Type for consumers (I) and producers (J)
variable {I J : Type*}
-- Finiteness and decidability assumptions for sums over I and J
[Fintype I] [Fintype J]
[DecidableEq I] [DecidableEq J]

-- A type for goods, represented as vectors in ℝ^n.
-- Elements are functions from `Fin n` (indices 0 to n-1) to `ℝ`.
def GoodsVector (n : ℕ) := (Fin n → ℝ)

-- Consumption bundle for consumer `i`. An allocation assigns a GoodsVector to each consumer.