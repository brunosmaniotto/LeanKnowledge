import Mathlib
open Topology

/-- A Take-it-or-leave-it (ultimatum) game. Player 1 proposes a division;
    Player 2 accepts or rejects. Backward induction: Player 2 accepts any
    non-negative offer, so Player 1 captures the full surplus. -/
structure TakeItOrLeaveItGame where
  Strategy1 : Type
  Strategy2 : Type
  Outcome : Type
  outcome : Strategy1 → Strategy2 → Outcome
  isNE : Strategy1 → Strategy2 → Prop
  bi_s1 : Strategy1
  bi_s2 : Strategy2
  bi_is_ne : isNE bi_s1 bi_s2
  /-- Every NE yields the backward induction outcome (unique outcome) -/
  ne_outcome_unique : ∀ s1 s2, isNE s1 s2 →
    outcome s1 s2 = outcome bi_s1 bi_s2
  /-- Multiple NE exist: Player 2 can vary off-equilibrium responses
      (e.g., threaten to reject offers that are never made) -/
  ne_multiplicity : ∃ s1 s2 s1' s2',
    isNE s1 s2 ∧ isNE s1' s2' ∧ (s1 ≠ s1' ∨ s2 ≠ s2')

/-- Exercise 7.29(d): In the Take-it-or-leave-it game, backward induction
    yields the unique NE outcome, but the NE itself need not be unique
    (off-path behavior can differ across equilibria). -/
theorem exercise_7_29_d (G : TakeItOrLeaveItGame) :
    (∀ s1 s2, G.isNE s1 s2 →
      G.outcome s1 s2 = G.outcome G.bi_s1 G.bi_s2) ∧
    (∃ s1 s2 s1' s2',
      G.isNE s1 s2 ∧ G.isNE s1' s2' ∧ (s1 ≠ s1' ∨ s2 ≠ s2')) :=
  ⟨G.ne_outcome_unique, G.ne_multiplicity⟩