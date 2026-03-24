import Mathlib
open Topology

namespace MatchingPenniesB

/-- Actions available in Matching Pennies -/
inductive Action
  | H  -- Heads
  | T  -- Tails
  deriving DecidableEq, Fintype, Repr

/-- Player 1's strategies in Matching Pennies Version B -/
inductive P1Strategy
  | H  -- play Heads
  | T  -- play Tails
  deriving DecidableEq, Fintype, Repr

/-- Player 2's strategies in Matching Pennies Version B.
    Each strategy specifies an action at both information sets:
    (action if P1 plays H, action if P1 plays T) -/
inductive P2Strategy
  | s1  -- (H if 1 plays H, H if 1 plays T)
  | s2  -- (H if 1 plays H, T if 1 plays T)
  | s3  -- (T if 1 plays H, H if 1 plays T)
  | s4  -- (T if 1 plays H, T if 1 plays T)
  deriving DecidableEq, Fintype, Repr

/-- Player 2's response given her strategy and Player 1's action -/
def P2Strategy.response : P2Strategy → P1Strategy → Action
  | .s1, _ => .H
  | .s2, .H => .H
  | .s2, .T => .T
  | .s3, .H => .T
  | .s3, .T => .H
  | .s4, _ => .T

end MatchingPenniesB