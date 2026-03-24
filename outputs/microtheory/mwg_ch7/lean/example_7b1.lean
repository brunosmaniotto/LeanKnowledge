import Mathlib

/-- Actions available to each player in Matching Pennies. -/
inductive Coin where
  | heads
  | tails
  deriving DecidableEq, Repr

/-- Matching Pennies: a two-player zero-sum game.
    Returns the payoff to (Player 1, Player 2).
    If pennies match, Player 2 wins (+1); if they differ, Player 1 wins (+1). -/
def matchingPenniesPayoff (p1 p2 : Coin) : ℤ × ℤ :=
  if p1 = p2 then (-1, 1) else (1, -1)