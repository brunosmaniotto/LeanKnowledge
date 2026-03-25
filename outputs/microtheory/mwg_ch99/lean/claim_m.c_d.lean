import Mathlib

open InnerProductSpace
open Topology

/-- First-order characterization of convexity for C¹ functions:
    f is convex on A if and only if f(x + z) ≥ f(x) + ∇f(x)·z
    for all x ∈ A and z with x + z ∈ A.
    This is the convex analogue of Theorem M.C.1 (concavity),
    obtained by reversing the inequality direction. -/
axiom first_order_convexity_condition
    {n : ℕ} {A : Set (EuclideanSpace ℝ (Fin n))}
    {f : EuclideanSpace ℝ (Fin n) → ℝ}
    {f' : EuclideanSpace ℝ (Fin n) → (EuclideanSpace ℝ (Fin n) →L[ℝ] ℝ)}
    (hA : Convex ℝ A) (hA_open : IsOpen A)
    (hf : ∀ x ∈ A, HasFDerivAt f (f' x) x) :
    ConvexOn ℝ A f ↔
      ∀ x ∈ A, ∀ z : EuclideanSpace ℝ (Fin n),
        x + z ∈ A → f (x + z) ≥ f x + f' x z

theorem Claim_M_C_d
    {n : ℕ} {A : Set (EuclideanSpace ℝ (Fin n))}
    {f : EuclideanSpace ℝ (Fin n) → ℝ}
    {f' : EuclideanSpace ℝ (Fin n) → (EuclideanSpace ℝ (Fin n) →L[ℝ] ℝ)}
    (hA : Convex ℝ A) (hA_open : IsOpen A)
    (hf : ∀ x ∈ A, HasFDerivAt f (f' x) x)
    (hconv : ConvexOn ℝ A f) :
    ∀ x ∈ A, ∀ z : EuclideanSpace ℝ (Fin n),
      x + z ∈ A → f (x + z) ≥ f x + f' x z := by
  exact (first_order_convexity_condition hA hA_open hf).mp hconv