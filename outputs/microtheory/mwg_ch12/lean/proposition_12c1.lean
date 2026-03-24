import Mathlib

noncomputable section

-- Define the constant marginal cost `c`. Assume `c` is non-negative.
variable (c : ℝ) (hc : 0 ≤ c)

-- Define the demand function `D`.
-- We assume `D` is non-negative, non-increasing, and positive at cost `c`.
-- We also assume demand eventually drops to zero for sufficiently high prices.
variable (D : ℝ → ℝ)
variable (hD_nonneg : ∀ p, 0 ≤ D p) -- Demand is always non-negative
variable (hD_decreasing : ∀ p1 p2, p1 < p2 → D p2 ≤ D p1) -- Demand is non-increasing
variable (hD_pos_c : D c > 0) -- Positive demand when price is at cost
-- Demand eventually drops to zero for sufficiently high prices, preventing infinite profits.
variable (hD_zero_above_some_price : ∃ P_max, ∀ p, P_max ≤ p → D p = 0)

open scoped Real
open Topology

-- `quantity_sold c D pi pj` represents the quantity sold by firm `i` (pricing at `pi`)
-- given rival firm `j`'s price `pj`.
-- If `pi < pj`, firm `i` captures the entire market demand `D pi`.
-- If `pi = pj`, firms split the market demand `D pi` evenly.
-- If `pi > pj`, firm `i` sells nothing.
def quantity_sold (pi pj : ℝ) : ℝ :=
  if pi < pj then D pi
  else if pi = pj then D pi / 2
  else 0

-- `profit c D pi pj` calculates the profit of firm `i` when pricing at `pi`
-- and rival `j` prices at `pj`.
-- Profit = (price - cost) * quantity_sold.