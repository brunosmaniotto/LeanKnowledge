import Mathlib

def bigAnd : List Prop → Prop
  | [] => True
  | P :: Ps => P ∧ bigAnd Ps