import Mathlib

inductive MP where | H | T deriving DecidableEq, Fintype

def pay1 (s1 s2 : MP) : ℤ := if s1 = s2 then 1 else -1