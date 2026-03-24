import Mathlib
open Topology

/-- In a pure strategy separating equilibrium of the insurance screening game,
    the low-risk consumer's policy lies exactly on the low-risk zero-profit line. -/
theorem claim_8_5_2
    (profit_l profit_h : ℝ)
    (h_high_risk : profit_h ≤ 0)
    (h_aggregate : profit_l + profit_h = 0)
    (h_no_strict : profit_l > 0 → False) :
    profit_l = 0 := by
  have h1 : profit_l ≤ 0 := not_lt.1 h_no_strict
  linarith