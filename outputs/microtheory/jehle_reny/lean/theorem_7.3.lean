import Mathlib
open Topology

-- From Exercise_7.1: A strategic form game consists of players, strategy sets, and payoff functions.
structure StrategicFormGame where
  Players : Type
  Strategy : Players → Type
  payoff : ((p : Players) → Strategy p) → Players → ℝ

namespace StrategicFormGame

-- A strategy profile for a strategic form game G.
def StrategyProfile (G : StrategicFormGame) : Type :=
  (p : G.Players) → G.Strategy p

-- Nash Equilibrium definition for a StrategicFormGame
-- A strategy profile `s` is a Nash Equilibrium if no player `p` can improve their payoff
-- by unilaterally changing their strategy from `s p` to `s_prime`.