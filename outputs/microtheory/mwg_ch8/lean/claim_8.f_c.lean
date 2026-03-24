import Mathlib

noncomputable section

structure FiniteGame where
  numPlayers : ℕ
  Strategy : Fin numPlayers → Type
  instF : ∀ i, Fintype (Strategy i)
  instN : ∀ i, Nonempty (Strategy i)
  utility : Fin numPlayers → (∀ j, Strategy j) → ℝ

def MixedProfile (G : FiniteGame) := ∀ i, G.Strategy i → ℝ