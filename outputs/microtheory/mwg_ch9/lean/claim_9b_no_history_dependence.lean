import Mathlib

structure RepeatedGame where
  T : ℕ
  Action : Type
  ne_action : Fin T → Action

def Strategy (G : RepeatedGame) := Fin G.T → List G.Action → G.Action