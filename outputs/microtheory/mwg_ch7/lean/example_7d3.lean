import Mathlib

inductive MP_B_P1 : Type
  | H | T
  deriving DecidableEq, Fintype, Repr

inductive MP_B_P2 : Type
  | s1 | s2 | s3 | s4
  deriving DecidableEq, Fintype, Repr

def matchingPenniesB_u1 : MP_B_P1 → MP_B_P2 → Int
  | .H, .s1 => -1
  | .H, .s2 => -1
  | .H, .s3 =>  1
  | .H, .s4 =>  1
  | .T, .s1 =>  1
  | .T, .s2 => -1
  | .T, .s3 =>  1
  | .T, .s4 => -1