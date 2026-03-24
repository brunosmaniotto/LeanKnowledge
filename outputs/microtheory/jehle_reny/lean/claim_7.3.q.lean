import Mathlib

inductive MPAct where | Heads | Tails deriving DecidableEq, Fintype, Repr

def u1 (a1 a2 : MPAct) : ℤ := if a1 = a2 then 1 else -1