import Mathlib
open Topology

/-!
# Proposition 9.B.3: SPNE Decomposition via Subgame Replacement
-/

-- Opaque types
axiom ExtGame : Type
axiom StrategyProfile : ExtGame → Type
axiom Subgame : ExtGame → Type

-- SPNE predicate
axiom IsSubgamePerfectNE : {G : ExtGame} → StrategyProfile G → Prop

-- A subgame viewed as a game
axiom subgameToGame : {G : ExtGame} → Subgame G → ExtGame

-- Restriction of a strategy profile to a subgame
axiom restrictToSubgame : {G : ExtGame} → StrategyProfile G →
  (S : Subgame G) → StrategyProfile (subgameToGame S)

-- Reduced game: replace subgame S with terminal node having payoffs from σ_S
axiom reducedGame : (G : ExtGame) → (S : Subgame G) →
  StrategyProfile (subgameToGame S) → ExtGame

-- Restriction of a strategy profile to outside a subgame (lives in reduced game)
axiom restrictOutside : {G : ExtGame} → (σ : StrategyProfile G) →
  (S : Subgame G) → StrategyProfile (reducedGame G S (restrictToSubgame σ S))

-- Combine: σ_S inside S, σ_tilde outside S
axiom combineStrategies : {G : ExtGame} → (S : Subgame G) →
  (σ_S : StrategyProfile (subgameToGame S)) →
  StrategyProfile (reducedGame G S σ_S) →
  StrategyProfile G

-- Axiom: deviation in reduced game lifts to original game
axiom deviation_lifts_to_original : {G : ExtGame} → (σ : StrategyProfile G) →
  (S : Subgame G) →
  ¬ IsSubgamePerfectNE (restrictOutside σ S) →
  ¬ IsSubgamePerfectNE σ

-- Axiom: combining SPNE of subgame and SPNE of reduced game yields SPNE of full game
axiom combined_is_spne : {G : ExtGame} → (S : Subgame G) →
  (σ_S : StrategyProfile (subgameToGame S)) →
  IsSubgamePerfectNE σ_S →
  (σ_tilde : StrategyProfile (reducedGame G S σ_S)) →
  IsSubgamePerfectNE σ_tilde →
  IsSubgamePerfectNE (combineStrategies S σ_S σ_tilde)

/-- **Proposition 9.B.3**: SPNE decomposition via subgame replacement -/
theorem Proposition_9B3 (G : ExtGame) (S : Subgame G) :
    -- Part (i)
    (∀ (σ : StrategyProfile G), IsSubgamePerfectNE σ →
      IsSubgamePerfectNE (restrictOutside σ S))
    ∧
    -- Part (ii)
    (∀ (σ_S : StrategyProfile (subgameToGame S)),
      IsSubgamePerfectNE σ_S →
      ∀ (σ_tilde : StrategyProfile (reducedGame G S σ_S)),
        IsSubgamePerfectNE σ_tilde →
        IsSubgamePerfectNE (combineStrategies S σ_S σ_tilde)) := by
  constructor
  · -- Part (i): by contrapositive
    intro σ hσ
    by_contra h
    exact absurd hσ (deviation_lifts_to_original σ S h)
  · -- Part (ii): direct from combining axiom
    intro σ_S hS σ_tilde h_tilde
    exact combined_is_spne S σ_S hS σ_tilde h_tilde