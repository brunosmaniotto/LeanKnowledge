import Mathlib
open Topology

/-- Duopolists producing substitute goods face inverse demand schedules
    p₁ = 20 + (1/2)p₂ − q₁ and p₂ = 20 + (1/2)p₁ − q₂.
    Each firm has constant marginal cost 20 and no fixed costs.
    Each firm is a Cournot competitor in price.
    We verify the Cournot equilibrium prices and outputs. -/
theorem Exercise_4_13 :
    -- Solving the system: profit_j = (pj - 20) * qj where qj = 20 + (1/2)pk - pj
    -- FOC for firm 1: d/dp1 [(p1 - 20)(20 + p2/2 - p1)] = 0
    --   => 20 + p2/2 - 2*p1 + 20 = 0 => p2/2 - 2*p1 + 40 = 0
    -- By symmetry p1 = p2 = p*: p*/2 - 2*p* + 40 = 0 => -3p*/2 + 40 = 0 => p* = 80/3
    -- q* = 20 + p*/2 - p* = 20 + 40/3 - 80/3 = 20 - 40/3 = 20/3
    -- Equilibrium prices
    let p_star : ℚ := 80 / 3
    -- Equilibrium quantities
    let q_star : ℚ := 20 / 3
    -- Verify inverse demand: p1 = 20 + (1/2)*p2 - q1
    p_star = 20 + (1/2) * p_star - q_star ∧
    -- Verify FOC: d/dp [(p - 20)(20 + p_star/2 - p)] evaluated at p = p_star equals 0
    -- FOC: 20 + p_star/2 - 2*p_star + 20 = 0
    (20 : ℚ) + p_star / 2 - 2 * p_star + 20 = 0 ∧
    -- Verify quantities are positive
    0 < q_star ∧
    -- Verify profit = (p* - 20) * q*
    (p_star - 20) * q_star = 400 / 9 := by
  constructor
  · norm_num
  constructor
  · norm_num
  constructor
  · norm_num
  · norm_num