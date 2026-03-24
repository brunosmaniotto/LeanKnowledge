import Mathlib

inductive Alt2 : Type where
  | a | b
  deriving DecidableEq, Fintype, Repr, Inhabited

def majorityVote (v1 v2 v3 : Alt2) : Alt2 :=
  match v1, v2, v3 with
  | Alt2.a, Alt2.a, _ => Alt2.a
  | Alt2.a, _, Alt2.a => Alt2.a
  | _, Alt2.a, Alt2.a => Alt2.a
  | _, _, _ => Alt2.b