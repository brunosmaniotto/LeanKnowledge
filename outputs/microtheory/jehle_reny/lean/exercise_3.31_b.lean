import Mathlib
open Topology

def HomogDeg1 {n : ℕ} (f : (Fin n → ℝ) → ℝ) : Prop :=
  ∀ (α : ℝ) (z : Fin n → ℝ), 0 ≤ α → f (α • z) = α * f z