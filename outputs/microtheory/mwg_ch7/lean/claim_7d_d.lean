import Mathlib

structure SimultaneousGame where
  Player : Type
  Action : Player → Type
  payoff : (∀ p, Action p) → Player → ℝ

def SimultaneousGame.Strategy (G : SimultaneousGame) (p : G.Player) : Type :=
  G.Action p