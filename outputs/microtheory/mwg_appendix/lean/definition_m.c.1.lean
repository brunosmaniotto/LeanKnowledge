import Mathlib

def MWG.IsConcaveOn (N : ℕ) (A : Set (EuclideanSpace ℝ (Fin N)))
    (f : EuclideanSpace ℝ (Fin N) → ℝ) : Prop :=
  Convex ℝ A ∧
    ∀ x x' : EuclideanSpace ℝ (Fin N), x ∈ A → x' ∈ A →
      ∀ α : ℝ, 0 ≤ α → α ≤ 1 →
        f (α • x' + (1 - α) • x) ≥ α * f x' + (1 - α) * f x