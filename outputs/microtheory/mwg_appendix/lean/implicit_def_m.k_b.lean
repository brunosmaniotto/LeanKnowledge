import Mathlib

open Set Topology

/-- A point x₀ ∈ C is a local constrained maximizer of f on C if there exists an open
neighborhood A of x₀ such that f(x₀) ≥ f(x) for all x ∈ A ∩ C. -/
structure MWG.IsLocalConstrainedMax {N : ℕ} (f : EuclideanSpace ℝ (Fin N) → ℝ)
    (C : Set (EuclideanSpace ℝ (Fin N))) (x₀ : EuclideanSpace ℝ (Fin N)) : Prop where
  feasible : x₀ ∈ C
  localMax : ∃ A : Set (EuclideanSpace ℝ (Fin N)), IsOpen A ∧ x₀ ∈ A ∧
    ∀ x ∈ A ∩ C, f x₀ ≥ f x

/-- A point x₀ ∈ C is a global constrained maximizer of f on C if f(x₀) ≥ f(x) for all x ∈ C. -/
structure MWG.IsGlobalConstrainedMax {N : ℕ} (f : EuclideanSpace ℝ (Fin N) → ℝ)
    (C : Set (EuclideanSpace ℝ (Fin N))) (x₀ : EuclideanSpace ℝ (Fin N)) : Prop where
  feasible : x₀ ∈ C
  globalMax : ∀ x ∈ C, f x₀ ≥ f x