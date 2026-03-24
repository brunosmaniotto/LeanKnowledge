import Mathlib
open Topology

-- Define the types for core components of the game
@[reducible] def Firm : Type := Fin 2 -- Two identical firms (firm 0 and firm 1)
@[reducible] def Period : Type := ℕ -- Time periods t = 0, 1, 2, ...
@[reducible] def Price : Type := ℝ -- Prices are real numbers
@[reducible] def Payoff : Type := ℝ -- Payoffs are real numbers

-- An outcome of a single period is the pair of prices chosen by the two firms.
-- Represented as a function from Firm to Price for clarity on which price belongs to which firm.
def PeriodOutcome : Type := Firm → Price

-- The history at the beginning of period `t` (0-indexed) is a sequence of `PeriodOutcome`s from periods `0` to `t-1`.
-- This corresponds to H_{t-1} in the problem statement (if t is 1-indexed in problem).