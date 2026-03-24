import Mathlib
open Topology

/-- A production path is stationary (steady state) if there exists a single
    production plan in Y such that every element of the path equals it. -/
def ProductionPath.IsStationary {n : ℕ} (Y : Set (Fin n → ℝ)) (path : ℕ → (Fin n → ℝ)) : Prop :=
  ∃ ybar ∈ Y, ∀ t, path t = ybar