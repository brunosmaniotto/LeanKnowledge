import Mathlib

namespace Example_7B2

inductive Player where | X | O
  deriving DecidableEq, Repr

def Player.other : Player → Player
  | .X => .O
  | .O => .X

abbrev Pos := Fin 3 × Fin 3

abbrev Board := Pos → Option Player