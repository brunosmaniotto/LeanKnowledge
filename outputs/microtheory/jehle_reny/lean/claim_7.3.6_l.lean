import Mathlib

/-!
We model the game from Fig. 7.25 as a one-player game without perfect recall.
The player has two information sets:
  - First move: choose L or R
  - Second move: choose l or r, but cannot recall the first move.
Pure strategies are pairs (first move, second move).
A behavioural strategy consists of two independent distributions:
  - σ₁ on {L,R}
  - σ₂ on {l,r}
The mixed strategy we consider assigns probability 1/2 to (L,l) and 1/2 to (R,r).
We show that no behavioural strategy can induce the same distribution over terminal nodes.
-/

-- Action sets for the two stages
inductive FirstMove : Type
  | L
  | R
deriving DecidableEq, Fintype

inductive SecondMove : Type
  | l
  | r
deriving DecidableEq, Fintype

open FirstMove SecondMove

-- Terminal nodes (outcomes) are pairs
noncomputable abbrev Outcome := FirstMove × SecondMove

-- The specific mixed strategy: 1/2 on (L,l), 1/2 on (R,r), 0 elsewhere
noncomputable def mixedStrategy : Outcome → ℝ
  | (L, l) => 1/2
  | (R, r) => 1/2
  | _      => 0