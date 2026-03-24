import Mathlib

structure FiniteGame where
  Player : Type
  [decEqPlayer : DecidableEq Player]
  Strategy : Player → Type
  Terminal : Type
  outcome : (∀ i, Strategy i) → Terminal
  payoff : Terminal → Player → ℝ
  isFinite : Prop
  isPerfectInfo : Prop

attribute [instance] FiniteGame.decEqPlayer

def IsNashEquilibrium (G : FiniteGame) (σ : ∀ i, G.Strategy i) : Prop :=
  ∀ (i : G.Player) (sᵢ : G.Strategy i),
    G.payoff (G.outcome (Function.update σ i sᵢ)) i ≤
    G.payoff (G.outcome σ) i