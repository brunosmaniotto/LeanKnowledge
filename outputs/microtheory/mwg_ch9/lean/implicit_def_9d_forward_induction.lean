import Mathlib
open Topology

/-- Forward induction is a reasoning principle where a player determines her optimal
action by assuming that other players must have behaved rationally in their previous
decisions. Unlike backward induction (which reasons about future rational actions),
forward induction reasons about what could have rationally happened previously.

This is formalized as a structure capturing: a game with information sets,
a rationality criterion over strategies, and a belief-revision function that,
at any information set, restricts beliefs to only those opponent strategy profiles
consistent with past rational play. The key property is that dominated strategies
are excluded from the support of beliefs at unreached information sets. -/
structure ForwardInduction (Player : Type*) (Action : Type*) (History : Type*)
    (InfoSet : Type*) [DecidableEq Player] [DecidableEq Action] [Fintype Action] where
  /-- Assignment of information sets to players -/
  playerOf : InfoSet → Player
  /-- The set of histories consistent with reaching a given information set -/
  historiesAt : InfoSet → Set History
  /-- A strategy maps information sets to actions -/
  Strategy := InfoSet → Action
  /-- Rationality criterion: whether a strategy is rational for a player
      given beliefs about opponent strategies -/
  isRational : Player → (InfoSet → Action) → (Player → InfoSet → Action) → Prop
  /-- Belief revision function: given an information set, returns the set of
      opponent strategy profiles that are consistent with rational past play -/
  rationalBeliefs : InfoSet → Set (Player → InfoSet → Action)
  /-- Forward induction requirement: beliefs at every information set only assign
      positive probability to opponent strategies that are rational given the
      history of play leading to that information set -/
  beliefs_support_rational : ∀ (h : InfoSet) (σ : Player → InfoSet → Action),
    σ ∈ rationalBeliefs h →
      ∀ (p : Player), p ≠ playerOf h → isRational p (σ p) σ
  /-- Dominated strategies are excluded: if a strategy is strictly dominated,
      it cannot appear in the rational beliefs at any information set -/
  dominated_excluded : ∀ (h : InfoSet) (p : Player) (s : InfoSet → Action),
    (∃ s' : InfoSet → Action, ∀ oppStrat : Player → InfoSet → Action,
      isRational p s' oppStrat ∧ ¬isRational p s oppStrat) →
    ∀ σ ∈ rationalBeliefs h, σ p ≠ s