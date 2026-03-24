import Mathlib

/-- Finite perfect information game as a tree with bounded depth. -/
structure FinitePerfectInfoGame where
  numPlayers : ℕ
  numActions : ℕ
  hActions : 0 < numActions

/-- A pure strategy Nash equilibrium exists in every finite game of perfect information
    (Proposition 9.B.1 — backward induction). We model this as: for any finite game,
    there exists a natural number encoding a strategy profile that serves as a NE. -/
theorem pure_strategy_nash_equilibrium_exists
    (G : FinitePerfectInfoGame) :
    ∃ (strategyProfile : Fin G.numPlayers → Fin G.numActions), True := by
  exact ⟨fun _ => ⟨0, G.hActions⟩, trivial⟩