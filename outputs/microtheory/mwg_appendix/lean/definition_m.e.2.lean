import Mathlib

open Matrix

/-- A system of equations f(·; q) = 0 is regular at q̄ if for every solution x
    (i.e., f(x, q̄) = 0), the Fréchet derivative D_x f(x, q̄) is a linear equivalence
    (i.e., invertible). This captures the condition |D_x f(x; q̄)| ≠ 0. -/
def MWG.IsRegularAt {N M : ℕ}
    (A : Set (EuclideanSpace ℝ (Fin N)))
    (B : Set (EuclideanSpace ℝ (Fin M)))
    (f : EuclideanSpace ℝ (Fin N) → EuclideanSpace ℝ (Fin M) → EuclideanSpace ℝ (Fin N))
    (q_bar : EuclideanSpace ℝ (Fin M)) : Prop :=
  ∀ x ∈ A, f x q_bar = 0 →
    ∃ L : EuclideanSpace ℝ (Fin N) ≃L[ℝ] EuclideanSpace ℝ (Fin N),
      fderiv ℝ (fun x' => f x' q_bar) x = (L : EuclideanSpace ℝ (Fin N) →L[ℝ] EuclideanSpace ℝ (Fin N))