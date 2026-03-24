import Mathlib

/-- A correspondence from A ⊂ ℝ^N to ℝ^K assigns to every x ∈ A a set f(x) ⊂ ℝ^K. -/
def MWG.Correspondence (N K : ℕ) (A : Set (EuclideanSpace ℝ (Fin N))) :=
  ∀ x ∈ A, Set (EuclideanSpace ℝ (Fin K))