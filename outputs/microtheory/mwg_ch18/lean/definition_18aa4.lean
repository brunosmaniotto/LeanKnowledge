import Mathlib
open BigOperators

/-- A transferable utility game (TU-game) in characteristic form. -/
structure TUGame where
  /-- The number of players -/
  I : Type*
  [finI : Fintype I]
  [decI : DecidableEq I]
  /-- The characteristic function assigning worth to each coalition -/
  v : Finset I → ℝ
  /-- The empty coalition has zero worth -/
  v_empty : v ∅ = 0

attribute [instance] TUGame.finI TUGame.decI

namespace TUGame

variable (G : TUGame)

/-- The utility possibility set for coalition S: all utility vectors where
    the sum of utilities does not exceed the worth of S. -/
noncomputable def utilityPossibilitySet (S : Finset G.I) : Set (G.I → ℝ) :=
  {u | ∑ i ∈ S, u i ≤ G.v S}

end TUGame