import Mathlib

/-- The transformation frontier: the set of boundary points {y ∈ ℝ^L | F(y) = 0}. -/
def transformationFrontier (L : ℕ) (F : (Fin L → ℝ) → ℝ) : Set (Fin L → ℝ) :=
  {y | F y = 0}