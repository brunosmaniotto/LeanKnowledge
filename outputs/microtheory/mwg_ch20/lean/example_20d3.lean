import Mathlib

noncomputable section

open Finset BigOperators

structure CostAdjModel where
  δ : ℝ
  F' : ℝ → ℝ
  γ' : ℝ → ℝ
  hδ_pos : 0 < δ

structure CapacityPath (m : CostAdjModel) where
  k : ℕ → ℝ

def SatisfiesEuler (m : CostAdjModel) (p : CapacityPath m) : Prop :=
  ∀ t : ℕ, t ≥ 1 →
    1 + m.γ' (p.k t - p.k (t - 1)) =
      m.δ * (m.F' (p.k t) + m.γ' (p.k (t + 1) - p.k t))