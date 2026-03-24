import Mathlib

theorem Exercise_4_22_c
    (c F q : ℝ)
    (hF_pos : F > 0)
    (hq_pos : q > 0)
    -- Surplus maximization requires p = c (marginal cost pricing)
    (p : ℝ)
    (hp : p = c)
    -- Revenue at price p
    (revenue : ℝ)
    (hrev : revenue = p * q)
    -- Total cost with fixed cost F
    (total_cost : ℝ)
    (htc : total_cost = c * q + F)
    -- Profit is revenue minus total cost
    (profit : ℝ)
    (hprofit : profit = revenue - total_cost) :
    profit = -F ∧ profit < 0 := by
  constructor
  · -- profit = p*q - (c*q + F) = c*q - c*q - F = -F
    rw [hprofit, hrev, htc, hp]
    ring
  · -- profit = -F < 0 since F > 0
    rw [hprofit, hrev, htc, hp]
    linarith