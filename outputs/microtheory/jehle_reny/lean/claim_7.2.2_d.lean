import Mathlib
open Finset BigOperators
open Topology

-- Pitcher's payoff function: takes pitcher's strategy (p_strat) and batter's strategy (b_strat)
-- returns a real number representing pitcher's payoff.
-- Strategies are represented by Fin 2, where 0 is 'F' and 1 is 'C'.
def pitcher_payoff_matrix (p_strat : Fin 2) (b_strat : Fin 2) : ℝ :=
  match p_strat, b_strat with
  | 0, 0 => -1 -- Pitcher F, Batter F
  | 0, 1 => 1  -- Pitcher F, Batter C
  | 1, 0 => 1  -- Pitcher C, Batter F
  | 1, 1 => -1 -- Pitcher C, Batter C

-- Batter's payoff function: a zero-sum game, so batter's payoff is the negative of pitcher's.