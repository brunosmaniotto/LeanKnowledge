import Mathlib

-- Finite extensive-form game of perfect information
structure FinitePerfectInfoGame where
  Node : Type
  Player : Type
  numTerminal : ℕ
  numTerminal_pos : 0 < numTerminal
  [finNode : Fintype Node]
  [finPlayer : Fintype Player]
  [decEqNode : DecidableEq Node]

namespace FinitePerfectInfoGame

variable (G : FinitePerfectInfoGame)

def Strategy := G.Node → ℕ