import Mathlib

-- Define the strategies for both players
inductive Strategy : Type
| F : Strategy -- Fastball
| C : Strategy -- Curveball
deriving DecidableEq, Repr

open Strategy

-- Define the payoff function for the batter
def batter_payoff (batter_strat : Strategy) (pitcher_strat : Strategy) : ℤ :=
  match batter_strat, pitcher_strat with
  | F, F => 1
  | F, C => -1
  | C, F => -1
  | C, C => 1

-- Define the payoff function for the pitcher