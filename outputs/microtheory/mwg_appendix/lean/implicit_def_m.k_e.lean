import Mathlib
open Topology

noncomputable def MWG.ConstraintQualificationInequality
    {n m k : ℕ}
    (g : Fin m → EuclideanSpace ℝ (Fin n) → ℝ)
    (b : Fin m → ℝ)
    (h : Fin k → EuclideanSpace ℝ (Fin n) → ℝ)
    (c : Fin k → ℝ)
    (x₀ : EuclideanSpace ℝ (Fin n)) : Prop :=
  let activeSet := {j : Fin k | h j x₀ = c j}
  let gradG : Fin m → (EuclideanSpace ℝ (Fin n) →L[ℝ] ℝ) :=
    fun i => fderiv ℝ (g i) x₀
  let gradH : activeSet → (EuclideanSpace ℝ (Fin n) →L[ℝ] ℝ) :=
    fun ⟨j, _⟩ => fderiv ℝ (h j) x₀
  LinearIndependent ℝ (Sum.elim gradG gradH)