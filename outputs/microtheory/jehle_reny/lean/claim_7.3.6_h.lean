import Mathlib

open BigOperators

-- We model the game described in Claim 7.3.6 and Figure 7.17/7.18.
-- Players are P1 and P2.
inductive Player where
| P1 | P2
deriving Fintype, DecidableEq

-- Payoffs are a vector of real numbers, one for each player.
-- Using Fin 2 to index players.
def Player.toFin : Player → Fin 2
| .P1 => 0
| .P2 => 1

-- Actions available in the subgame (the coordination game).
inductive P1_SubgameAction where
| L | R
deriving Fintype, DecidableEq

inductive P2_SubgameAction where
| l | r
deriving Fintype, DecidableEq

-- Payoff function for the subgame, based on the description of a coordination game.
-- (L,l) and (R,r) are equilibria.