import Mathlib
open BigOperators

namespace Example7_6

-- To avoid name clashes with Mathlib, we define local types for actions and information sets.
inductive P1_Action | L | R deriving Fintype, DecidableEq
inductive P1_InfoSet | I₁ | I₂ deriving Fintype, DecidableEq

-- A pure strategy for Player 1 is a function from their information sets to actions.
abbrev P1_PureStrategy := P1_InfoSet → P1_Action

-- The three pure strategies for player 1 mentioned in the example.
def s_LL : P1_PureStrategy := fun _ => .L