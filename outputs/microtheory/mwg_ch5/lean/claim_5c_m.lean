import Mathlib
open Topology

def IsQuasiconcave {n : ℕ} (f : (Fin n → ℝ) → ℝ) : Prop :=
  ∀ q : ℝ, Convex ℝ {z : Fin n → ℝ | f z ≥ q}