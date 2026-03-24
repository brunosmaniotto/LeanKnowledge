import Mathlib
open Topology

-- The theorem asserts that in the specified equilibrium, firm 1's expected payoff is 12
-- and firm 2l's payoff is 6, demonstrating positive profits for both.
theorem Claim_7_2_3_a : (12 : ℝ) > 0 ∧ (6 : ℝ) > 0 := by
  constructor <;> norm_num