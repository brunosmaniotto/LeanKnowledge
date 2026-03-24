import Mathlib
open Topology

/-- A demand correspondence is homogeneous of degree zero if scaling both
    prices and wealth by the same positive scalar leaves demand unchanged. -/
def IsHomogeneousOfDegreeZero {n : ℕ}
    (x : (Fin n → ℝ) → ℝ → Set (Fin n → ℝ)) : Prop :=
  ∀ (p : Fin n → ℝ) (w : ℝ) (α : ℝ), α > 0 →
    x (α • p) (α * w) = x p w