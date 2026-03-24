import Mathlib

structure MoralHazardInsurance where
  profit_high : ℝ
  profit_low : ℝ
  utility_high : ℝ
  utility_low : ℝ
  high_effort_better : profit_high > profit_low
  utility_unchanged : utility_high = utility_low

def isParetoInefficient (m : MoralHazardInsurance) : Prop :=
  m.profit_low < m.profit_high ∧ m.utility_low ≤ m.utility_high