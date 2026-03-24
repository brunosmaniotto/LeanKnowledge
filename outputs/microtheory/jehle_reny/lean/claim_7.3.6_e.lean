import Mathlib

/-- An I-player extensive form game Γₑ, parameterized abstractly by its
    strategy profiles, subgames, and the Nash equilibrium predicate on subgames. -/
structure ExtensiveFormGame (I : Type*) where
  /-- Type of strategy profiles σ = (σ₁, ..., σᵢ) -/
  StrategyProfile : Type*
  /-- Type indexing subgames of Γₑ -/
  SubgameIndex : Type*
  /-- The strategy profile induced by σ in a given subgame -/
  inducedProfile : StrategyProfile → SubgameIndex → StrategyProfile
  /-- Predicate: σ is a Nash equilibrium in the subgame indexed by g -/
  isNashEq : SubgameIndex → StrategyProfile → Prop
  /-- The specific subgame index representing the game as a whole (defined by its root node). -/
  wholeGameSubgame : SubgameIndex

/-- A strategy profile σ in an I-player extensive form game Γₑ is a
    **subgame perfect Nash equilibrium** (SPNE) if it induces a Nash equilibrium
    in every subgame of Γₑ. (Selten, 1965) -/
def ExtensiveFormGame.IsSubgamePerfectNE {I : Type*} (Γ : ExtensiveFormGame I)
    (σ : Γ.StrategyProfile) : Prop :=
  ∀ g : Γ.SubgameIndex, Γ.isNashEq g (Γ.inducedProfile σ g)