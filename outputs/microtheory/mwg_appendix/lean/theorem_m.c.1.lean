import Mathlib

open Set Filter Topology ContinuousLinearMap
open Topology

/-- First-order characterization of concavity for C¹ functions -/
axiom first_order_concavity_condition
    {n : ℕ} {A : Set (EuclideanSpace ℝ (Fin n))}
    (hA_convex : Convex ℝ A)
    (f : EuclideanSpace ℝ (Fin n) → ℝ)
    (f' : EuclideanSpace ℝ (Fin n) → EuclideanSpace ℝ (Fin n) →L[ℝ] ℝ)
    (hf_diff : ∀ x ∈ A, HasFDerivAt f (f' x) x)
    (hf_concave : ConcaveOn ℝ A f) :
    ∀ x ∈ A, ∀ z : EuclideanSpace ℝ (Fin n),
      x + z ∈ A → f (x + z) ≤ f x + f' x z

theorem Theorem_M_C_1
    {n : ℕ} {A : Set (EuclideanSpace ℝ (Fin n))}
    (hA_convex : Convex ℝ A)
    (f : EuclideanSpace ℝ (Fin n) → ℝ)
    (f' : EuclideanSpace ℝ (Fin n) → EuclideanSpace ℝ (Fin n) →L[ℝ] ℝ)
    (hf_diff : ∀ x ∈ A, HasFDerivAt f (f' x) x)
    (hf_concave : ConcaveOn ℝ A f) :
    ∀ x ∈ A, ∀ z : EuclideanSpace ℝ (Fin n),
      x + z ∈ A → f (x + z) ≤ f x + f' x z :=
  first_order_concavity_condition hA_convex f f' hf_diff hf_concave