import Mathlib

open Set
open Topology

variable {n : ℕ} {D : Set (Fin n → ℝ)} {f : (Fin n → ℝ) → ℝ}

/-- The epigraph of f on D: {(x, y) | x ∈ D, f(x) ≤ y} -/
def epigraph (D : Set (Fin n → ℝ)) (f : (Fin n → ℝ) → ℝ) : Set ((Fin n → ℝ) × ℝ) :=
  {p | p.1 ∈ D ∧ f p.1 ≤ p.2}