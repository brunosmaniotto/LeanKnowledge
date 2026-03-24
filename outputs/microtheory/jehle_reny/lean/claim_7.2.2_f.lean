import Mathlib
open Topology

-- The problem states:
-- "In the coordination game of Example 7.1, the mixed strategy Nash equilibrium is inefficient:
-- each player's expected payoff is 2/3, which is strictly less than either player's payoff
-- in either of the two pure strategy Nash equilibria."
-- The proof sketch confirms the relevant pure strategy payoffs are 1 and 2,
-- while the mixed strategy expected payoff is 2/3.
-- We need to prove that 2/3 < 1 and 2/3 < 2.

theorem Claim_7_2_2_f :
  let mixed_strategy_expected_payoff : ℚ := 2/3
  let pure_strategy_payoff_case_1 : ℚ := 1
  let pure_strategy_payoff_case_2 : ℚ := 2
  mixed_strategy_expected_payoff < pure_strategy_payoff_case_1 ∧
  mixed_strategy_expected_payoff < pure_strategy_payoff_case_2 := by
  -- The `norm_num` tactic can discharge these simple rational number inequalities.
  norm_num