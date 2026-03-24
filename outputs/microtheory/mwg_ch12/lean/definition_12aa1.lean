import Mathlib
open Topology

/-- A Nash reversion strategy profile in an infinitely repeated game.
    Players follow outcome path Q until someone defects, then play
    the stage game Nash equilibrium q* forever after.
    History is modeled as a function from time to action profiles. -/
structure NashReversionStrategy (ActionSpace : Fin 2 → Type*) where
  /-- The cooperative outcome path before any defection -/
  outcomePath : ℕ → (i : Fin 2) → ActionSpace i
  /-- The stage game Nash equilibrium played after defection -/
  nashEquilibrium : (i : Fin 2) → ActionSpace i
  /-- The strategy for each player: given current time and history of past action profiles,
      produce an action. -/
  strategy : (i : Fin 2) → (t : ℕ) → (history : Fin t → (j : Fin 2) → ActionSpace j) → ActionSpace i
  /-- Before any defection, strategy follows the outcome path -/
  follows_path : ∀ (i : Fin 2) (t : ℕ) (history : Fin t → (j : Fin 2) → ActionSpace j),
    (∀ (s : Fin t) (j : Fin 2), history s j = outcomePath s.val j) →
    strategy i t history = outcomePath t i
  /-- After a defection, strategy plays Nash equilibrium -/
  reverts_to_nash : ∀ (i : Fin 2) (t : ℕ) (history : Fin t → (j : Fin 2) → ActionSpace j),
    (∃ (s : Fin t) (j : Fin 2), history s j ≠ outcomePath s.val j) →
    strategy i t history = nashEquilibrium i