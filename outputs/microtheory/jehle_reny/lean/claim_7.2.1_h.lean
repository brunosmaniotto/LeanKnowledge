import Mathlib
open Topology

-- Define the players
inductive Player : Type
  | batter : Player
  | pitcher : Player
  deriving DecidableEq, Fintype, Inhabited

-- Define the strategies for each player
inductive Strategy : Type
  | strategy_A : Strategy
  | strategy_B : Strategy
  deriving DecidableEq, Fintype, Inhabited

-- A strategy profile is a choice of strategy for each player
abbrev StrategyProfile := Strategy × Strategy

-- Define the payoff function
-- (Batter strategy, Pitcher strategy) -> (Batter payoff, Pitcher payoff)
-- Payoff matrix for Player.batter:
--             P_Strategy_A    P_Strategy_B
-- B_Strategy_A       1            -1
-- B_Strategy_B      -1             1
--
-- Payoff matrix for Player.pitcher:
--             P_Strategy_A    P_Strategy_B
-- B_Strategy_A      -1             1
-- B_Strategy_B       1            -1
def payoff (p : Player) (profile : StrategyProfile) : ℝ :=
  let (s_batter, s_pitcher) := profile
  match p with
  | Player.batter =>
    if s_batter = s_pitcher then 1 else -1
  | Player.pitcher =>
    if s_batter = s_pitcher then -1 else 1

-- Function to create a strategy profile given player p's strategy and opponent's strategy