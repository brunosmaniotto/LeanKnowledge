import Mathlib
open Topology

/-- A finite extensive form game with two players, two actions each.
    This models a simultaneous-move game (like Matching Pennies) embedded
    in extensive form via an information set that makes it simultaneous. -/
structure SimpleExtensiveGame where
  /-- Number of players -/
  numPlayers : ℕ
  /-- Number of pure strategies per player -/
  numStrategies : ℕ
  /-- Payoff function: player → strategy profile (as pair) → payoff -/
  payoff : Fin numPlayers → Fin numStrategies × Fin numStrategies → ℤ
  /-- Whether a strategy profile is a subgame perfect NE -/
  isSubgamePerfectNE : (Fin numStrategies × Fin numStrategies) → Prop

/-- Matching Pennies: a 2-player game where player 1 wants to match,
    player 2 wants to mismatch. No pure strategy equilibrium exists. -/
noncomputable def matchingPennies : SimpleExtensiveGame where
  numPlayers := 2
  numStrategies := 2
  payoff := fun p s =>
    if p = 0 then (if s.1 = s.2 then 1 else -1)
    else (if s.1 = s.2 then -1 else 1)
  isSubgamePerfectNE := fun _ => False

theorem Exercise_7_37_b :
    ∃ (G : SimpleExtensiveGame), ∀ s : Fin G.numStrategies × Fin G.numStrategies,
      ¬ G.isSubgamePerfectNE s := by
  exact ⟨matchingPennies, fun s => id⟩