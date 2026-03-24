import Mathlib
open Function
open Finset
open Topology

-- Variables for strategy types and payoff functions in a two-player game.
-- We assume finite and decidable equality for strategy spaces, and that they are non-empty.
variable {S1 S2 : Type} [Inhabited S1] [DecidableEq S1] [Fintype S1]
variable [Inhabited S2] [DecidableEq S2] [Fintype S2]
variable (u1 : S1 → S2 → ℝ) (u2 : S1 → S2 → ℝ)

/--
  A strategy `s_dom` is strictly dominant for Player 1 if it yields a strictly higher payoff
  than any other strategy `s1'` for Player 1, regardless of Player 2's strategy `s2`.
-/
def Player1StrictlyDominant (s_dom : S1) : Prop :=
  ∀ s1' : S1, s1' ≠ s_dom → ∀ s2 : S2, u1 s1' s2 < u1 s_dom s2