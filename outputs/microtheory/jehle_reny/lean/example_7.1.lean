import Mathlib

open Classical BigOperators Finset MeasureTheory ProbabilityTheory

-- Define players for the coordination game
inductive GamePlayer : Type
  | P1 : GamePlayer
  | P2 : GamePlayer
  deriving DecidableEq, Fintype, Inhabited

-- Define actions for the coordination game
inductive CoordinationGameAction : Type
  | WP : CoordinationGameAction  -- Work Package
  | MW : CoordinationGameAction  -- Meeting Workflow
  deriving DecidableEq, Fintype, Inhabited

instance : ToString GamePlayer where
  toString := fun
    | .P1 => "P1"
    | .P2 => "P2"

instance : ToString CoordinationGameAction where
  toString := fun
    | .WP => "WP"
    | .MW => "MW"

-- Payoff function: (player, player1_action, player2_action) -> payoff
def payoff (player : GamePlayer) (p1_action : CoordinationGameAction) (p2_action : CoordinationGameAction) : ℝ :=
  match player, p1_action, p2_action with
  | .P1, .WP, .WP => 2
  | .P1, .WP, .MW => 0
  | .P1, .MW, .WP => 0
  | .P1, .MW, .MW => 1
  | .P2, .WP, .WP => 1
  | .P2, .WP, .MW => 0
  | .P2, .MW, .WP => 0
  | .P2, .MW, .MW => 2

-- A pure strategy profile is a pair of actions (one for each player)
abbrev PureStrategyProfile := CoordinationGameAction × CoordinationGameAction

-- Definition of a pure strategy Nash Equilibrium