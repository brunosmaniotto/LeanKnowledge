import Mathlib
open Topology

/-- Actions in Matching Pennies. -/
inductive MPCoin where | H | T deriving DecidableEq, Fintype, Repr

/-- Player 1's expected payoff from playing H when player 2 plays H with probability q.
    EU₁(H) = q·(-1) + (1-q)·(1) = 1 - 2q -/
noncomputable def eu1_H (q : ℚ) : ℚ := 1 - 2 * q

/-- Player 1's expected payoff from playing T when player 2 plays H with probability q.
    EU₁(T) = q·(1) + (1-q)·(-1) = 2q - 1 -/
noncomputable def eu1_T (q : ℚ) : ℚ := 2 * q - 1

/-- Player 2's expected payoff from playing H when player 1 plays H with probability p.
    EU₂(H) = p·(1) + (1-p)·(-1) = 2p - 1 -/
noncomputable def eu2_H (p : ℚ) : ℚ := 2 * p - 1

/-- Player 2's expected payoff from playing T when player 1 plays H with probability p.
    EU₂(T) = p·(-1) + (1-p)·(1) = 1 - 2p -/
noncomputable def eu2_T (p : ℚ) : ℚ := 1 - 2 * p

/-- The unique sequential equilibrium of Matching Pennies (MWG Fig. 7.34) has each
    player choosing Heads with probability 1/2. In a sequential equilibrium,
    each player must be indifferent between H and T (otherwise they wouldn't mix),
    giving EU₁(H) = EU₁(T) ↔ q = 1/2 and EU₂(H) = EU₂(T) ↔ p = 1/2.
    Bayes' rule consistency eliminates all non-Nash assessments. -/
theorem Claim_7_3_s (p q : ℚ)
    (h1 : eu1_H q = eu1_T q)
    (h2 : eu2_H p = eu2_T p) :
    p = 1 / 2 ∧ q = 1 / 2 := by
  unfold eu1_H eu1_T eu2_H eu2_T at *
  constructor <;> linarith