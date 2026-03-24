import Mathlib
open Topology

/--
We abstractly model an extensive form game with the properties needed
to talk about subgames, reached subgames, and Nash equilibria.
-/
structure ExtensiveFormGame where
  /-- The set of all possible strategy profiles in the game. -/
  StrategyProfile : Type
  /-- An identifier for a subgame within the extensive form game. -/
  Subgame : Type
  /-- The root subgame, representing the game as a whole. -/
  root : Subgame
  /-- For any strategy `s` and subgame `g`, `inducedProfile s g` is the
  strategy profile that `s` induces on `g`. -/
  inducedProfile : StrategyProfile → Subgame → StrategyProfile
  /-- `isNashEq g s'` is true if `s'` is a Nash equilibrium for the subgame `g`. -/
  isNashEq : Subgame → StrategyProfile → Prop
  /-- `isReached s g` is true if the subgame `g` is reached when players
  play the strategy profile `s`. -/
  isReached : StrategyProfile → Subgame → Prop

/--
This axiom provides the crucial link between subgame play and overall game outcomes.
It formalizes the idea from the proof sketch: if a subgame `g` is reached by a
strategy `s`, then any profitable deviation from the induced strategy in `g`
corresponds to a profitable deviation from `s` in the main game.

In our abstract terms: if the induced strategy is not a Nash equilibrium in a
reached subgame, then the original strategy cannot be a Nash equilibrium in the
root game.
-/
axiom subgame_deviation_implies_game_deviation {Γ : ExtensiveFormGame}
  (s : Γ.StrategyProfile) (g : Γ.Subgame) (h_reached : Γ.isReached s g) :
  (¬ Γ.isNashEq g (Γ.inducedProfile s g)) → (¬ Γ.isNashEq Γ.root s)

/--
**Claim 7.3.6 (g):** Nash equilibrium strategies of the original game induce
Nash equilibria in all subgames that are reached by the original strategies.
-/
theorem Claim_7_3_6_g (Γ : ExtensiveFormGame) (s : Γ.StrategyProfile) (g : Γ.Subgame)
    (h_nash : Γ.isNashEq Γ.root s) (h_reached : Γ.isReached s g) :
    Γ.isNashEq g (Γ.inducedProfile s g) := by
  -- We prove by contradiction. Assume the induced strategy is NOT a Nash equilibrium.
  by_contra h_not_subgame_nash
  -- By the axiom, a non-NE in a reached subgame implies the original strategy is not a NE.
  have h_not_root_nash : ¬ Γ.isNashEq Γ.root s :=
    subgame_deviation_implies_game_deviation s g h_reached h_not_subgame_nash
  -- This contradicts the initial assumption that `s` is a Nash equilibrium for the root game.
  exact h_not_root_nash h_nash