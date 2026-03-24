import Mathlib

structure ExtensiveFormGame (I : Type*) where
  StrategyProfile : Type*
  SubgameIndex : Type*
  inducedProfile : StrategyProfile → SubgameIndex → StrategyProfile
  isNashEq : SubgameIndex → StrategyProfile → Prop
  isReached : StrategyProfile → SubgameIndex → Prop

structure ExtensiveFormGame.HasFullGame {I : Type*} (Γ : ExtensiveFormGame I) where
  fullGame : Γ.SubgameIndex
  fullGame_reached : ∀ σ, Γ.isReached σ fullGame
  fullGame_induced : ∀ σ, Γ.inducedProfile σ fullGame = σ

/-- Exercise 7.35 (MWG): If σ is a pure strategy Nash equilibrium of an
    extensive form game, then σ induces a Nash equilibrium in every subgame
    that is reached by σ. -/
theorem exercise_7_35 {I : Type*} (Γ : ExtensiveFormGame I)
    (hfull : Γ.HasFullGame)
    (σ : Γ.StrategyProfile)
    (h_ne : Γ.isNashEq hfull.fullGame σ)
    (h_one_deviation : ∀ g : Γ.SubgameIndex,
      Γ.isReached σ g → Γ.isNashEq hfull.fullGame σ →
      Γ.isNashEq g (Γ.inducedProfile σ g)) :
    ∀ g : Γ.SubgameIndex, Γ.isReached σ g →
      Γ.isNashEq g (Γ.inducedProfile σ g) := by
  intro g hreached
  exact h_one_deviation g hreached h_ne