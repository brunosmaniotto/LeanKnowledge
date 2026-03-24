import Mathlib

inductive PDStrategy
  | Confess
  | DontConfess
  deriving DecidableEq, Fintype

open PDStrategy

def payoff1 : PDStrategy → PDStrategy → ℤ
  | Confess,     Confess     => -5
  | Confess,     DontConfess => 0
  | DontConfess, Confess     => -10
  | DontConfess, DontConfess => -1