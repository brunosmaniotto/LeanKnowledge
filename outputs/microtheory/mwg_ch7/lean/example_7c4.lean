import Mathlib

inductive MP.Player where | P1 | P2 deriving DecidableEq
inductive MPAction where | Heads | Tails deriving DecidableEq

def matchingPenniesPayoff (a1 a2 : MPAction) (p : MP.Player) : Int :=
  match p with
  | .P1 => if a1 == a2 then 1 else -1
  | .P2 => if a1 == a2 then -1 else 1