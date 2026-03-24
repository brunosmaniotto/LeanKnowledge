import Mathlib

inductive ActionE | in_ | out deriving DecidableEq
inductive ActionI | fight | accommodate deriving DecidableEq

def payoffI : ActionE → ActionI → Int
  | .out, _ => 2
  | .in_, .fight => -1
  | .in_, .accommodate => 1