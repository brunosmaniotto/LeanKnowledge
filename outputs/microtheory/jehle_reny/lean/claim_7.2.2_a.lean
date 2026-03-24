import Mathlib

-- Define strategy types for Player 1 (U, D) and Player 2 (L, R)
inductive P1Strat : Type
| U : P1Strat
| D : P1Strat
deriving DecidableEq, Repr

inductive P2Strat : Type
| L : P2Strat
| R : P2Strat
deriving DecidableEq, Repr

open P1Strat P2Strat

-- Define a structure for a 2-player game with Real payoffs
structure TwoPlayerGame where
  p1_payoff : P1Strat → P2Strat → ℝ
  p2_payoff : P1Strat → P2Strat → ℝ

-- Define what it means for a strategy profile (s1, s2) to be a pure strategy Nash Equilibrium
def IsNashEquilibrium (game : TwoPlayerGame) (s1 : P1Strat) (s2 : P2Strat) : Prop :=
  (∀ s1' : P1Strat, game.p1_payoff s1 s2 ≥ game.p1_payoff s1' s2) ∧
  (∀ s2' : P2Strat, game.p2_payoff s1 s2 ≥ game.p2_payoff s1 s2')

/-
Defining a hypothetical game for Fig 7.2 based on the proof sketch:
- (U,L) has P1 payoff 3, P2 payoff 0.
- P1 switching from U to D (given P2 plays L) reduces P1 payoff from 3 to 2.
- P2 switching from L to R (given P1 plays U) reduces P2 payoff from 0 to -4.
Other payoff values are chosen to satisfy the Nash Equilibrium conditions for (U,L).
-/