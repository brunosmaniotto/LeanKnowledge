import Mathlib

universe u

axiom Game : Type u
axiom StrategyProfile : Game → Type u
axiom IsFiniteExtensiveFormGame : Game → Prop
axiom HasPerfectRecall : Game → Prop
axiom IsSequentialEquilibrium : (Γ : Game) → StrategyProfile Γ → Prop
axiom IsSubgamePerfectEquilibrium : (Γ : Game) → StrategyProfile Γ → Prop

axiom Theorem_7_7 : ∀ (Γ : Game), IsFiniteExtensiveFormGame Γ → HasPerfectRecall Γ → 
  ∃ σ : StrategyProfile Γ, IsSequentialEquilibrium Γ σ

axiom sequential_implies_subgame_perfect : ∀ (Γ : Game) (σ : StrategyProfile Γ),
  IsSequentialEquilibrium Γ σ → HasPerfectRecall Γ → IsSubgamePerfectEquilibrium Γ σ

theorem Theorem_7_6 (Γ : Game) (h_fin : IsFiniteExtensiveFormGame Γ) (h_pr : HasPerfectRecall Γ) :
    ∃ σ : StrategyProfile Γ, IsSubgamePerfectEquilibrium Γ σ := by
  rcases Theorem_7_7 Γ h_fin h_pr with ⟨σ, h_seq⟩
  exact ⟨σ, sequential_implies_subgame_perfect Γ σ h_seq h_pr⟩