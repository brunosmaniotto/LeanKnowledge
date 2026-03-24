import Mathlib

open Function

structure FiniteSymmetricGame where
  Player : Type
  Strategy : Type
  [finPlayer : Fintype Player]
  [finStrategy : Fintype Strategy]
  [decPlayer : DecidableEq Player]
  [decStrategy : DecidableEq Strategy]
  [nePlayer : Nonempty Player]
  [neStrategy : Nonempty Strategy]
  payoff : (Player → Strategy) → Player → ℝ
  symm : ∀ (σ : Player → Strategy) (π : Equiv.Perm Player) (i : Player),
    payoff (σ ∘ π) i = payoff σ (π i)

attribute [instance] FiniteSymmetricGame.finPlayer
attribute [instance] FiniteSymmetricGame.finStrategy
attribute [instance] FiniteSymmetricGame.decPlayer
attribute [instance] FiniteSymmetricGame.decStrategy
attribute [instance] FiniteSymmetricGame.nePlayer
attribute [instance] FiniteSymmetricGame.neStrategy

def NormalFormGame.NashEquilibrium (G : FiniteSymmetricGame)
    (σ : G.Player → G.Strategy) : Prop :=
  ∀ (i : G.Player) (sᵢ : G.Strategy),
    G.payoff (update σ i sᵢ) i ≤ G.payoff σ i