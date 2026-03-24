import Mathlib

inductive MPAction : Type
  | Heads : MPAction
  | Tails : MPAction
  deriving DecidableEq, Fintype

abbrev P1StrategyB := MPAction
abbrev P1StrategyC := MPAction
abbrev P2StrategyB := MPAction → MPAction
abbrev P2StrategyC := MPAction

theorem Example_7D2_p1_same : P1StrategyB = P1StrategyC := rfl