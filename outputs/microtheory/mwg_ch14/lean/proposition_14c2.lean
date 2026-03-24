import Mathlib

inductive State where | L | H
deriving DecidableEq, Fintype

structure Outcome where
  wage : ℝ
  effort : ℝ

structure DirectMechanism where
  outcomeMap : State → Outcome

def IsTruthful (dm : DirectMechanism) (u : State → Outcome → ℝ) : Prop :=
  ∀ (θ θ' : State), u θ (dm.outcomeMap θ) ≥ u θ (dm.outcomeMap θ')