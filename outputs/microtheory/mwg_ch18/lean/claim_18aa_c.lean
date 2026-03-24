import Mathlib

structure ProductionGame where
  f : ℕ → ℝ
  f_zero : f 0 = 0

def StrictlyDecreasingReturns (G : ProductionGame) : Prop :=
  ∀ a b : ℕ, 0 < a → 0 < b → G.f a + G.f b > G.f (a + b)