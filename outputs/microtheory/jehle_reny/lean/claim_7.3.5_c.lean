import Mathlib
open Topology

-- Actions for the entrant and incumbent
inductive EntrantAction | enter | stayOut deriving DecidableEq, Fintype
inductive IncumbentAction | acquiesce | fight deriving DecidableEq, Fintype

-- Payoff function: returns ![entrant_payoff, incumbent_payoff]
def payoff (e : EntrantAction) (i : IncumbentAction) : Fin 2 → ℤ :=
  match e with
  | .stayOut => ![0, 2]
  | .enter   => match i with
                | .acquiesce => ![1, 1]
                | .fight     => ![-1, -1]

-- A strategy profile is a backward induction strategy if it satisfies these conditions.
structure IsBackwardInduction (e_strat : EntrantAction) (i_strat : IncumbentAction) : Prop where
  /-- Given entry, the incumbent's action must maximize their own payoff. -/
  incumbent_optimal : ∀ (i_alt : IncumbentAction), payoff .enter i_alt 1 ≤ payoff .enter i_strat 1
  /-- The entrant's action must maximize their payoff, anticipating the incumbent's optimal response. -/
  entrant_optimal : ∀ (e_alt : EntrantAction),
    (match e_alt with | .enter => payoff .enter i_strat 0 | .stayOut => payoff .stayOut i_strat 0) ≤
    (match e_strat with | .enter => payoff .enter i_strat 0 | .stayOut => payoff .stayOut i_strat 0)

-- Theorem: The unique backward induction strategy is (enter, acquiesce).