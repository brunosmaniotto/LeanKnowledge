import Mathlib

open scoped Classical -- Needed for DecidableEq instances for inductive types

-- Define players
inductive Player : Type
  | P1 : Player
  | P2 : Player
  deriving DecidableEq, Fintype

-- Define strategies for Player 1
inductive StratP1 : Type
  | U : StratP1
  | D : StratP1
  deriving DecidableEq, Fintype

-- Define strategies for Player 2
inductive StratP2 : Type
  | L : StratP2
  | R : StratP2
  deriving DecidableEq, Fintype

open Player StratP1 StratP2

-- Define the strategy space for each player
def strategies : Player → Type
  | P1 => StratP1
  | P2 => StratP2

instance : Fintype (strategies P1) := by delta strategies; infer_instance
instance : Fintype (strategies P2) := by delta strategies; infer_instance
instance : DecidableEq (strategies P1) := by delta strategies; infer_instance
instance : DecidableEq (strategies P2) := by delta strategies; infer_instance

-- Define the payoff function based on the problem description
-- The values are set such that (D, R) yields (0, 0) and any unilateral deviation
-- from (D, R) results in a payoff no greater than 0 for the deviating player.
noncomputable def game_payoff (i : Player) (σ : ∀ (j : Player), strategies j) : ℝ :=
  match i, σ P1, σ P2 with
  | P1, U, L => 1  -- Example payoff, not critical for (D,R) equilibrium
  | P1, U, R => 0  -- P1 payoff if P1 plays U, P2 plays R (deviation from (D,R))
  | P1, D, L => 0  -- P1 payoff if P1 plays D, P2 plays L (deviation from (D,R))
  | P1, D, R => 0  -- P1 payoff if P1 plays D, P2 plays R (the proposed NE)
  | P2, U, L => 1  -- Example payoff, not critical for (D,R) equilibrium
  | P2, U, R => 1  -- P2 payoff if P1 plays U, P2 plays R
  | P2, D, L => 0  -- P2 payoff if P1 plays D, P2 plays L (deviation from (D,R))
  | P2, D, R => 0  -- P2 payoff if P1 plays D, P2 plays R (the proposed NE)

-- Define the NormalFormGame structure for Fig. 7.4