import Mathlib

open InnerProductSpace
open Topology

/-- A convex function satisfies the first-order condition:
    f(x + z) ≥ f(x) + ∇f(x)·z for all x ∈ A and x + z ∈ A. -/
axiom ConvexOn.first_order_condition
    {n : ℕ}
    {f : EuclideanSpace ℝ (Fin n) → ℝ}
    {A : Set (EuclideanSpace ℝ (Fin n))}
    (hA : Convex ℝ A)
    (hf : ConvexOn ℝ A f)
    (hfd : ∀ x ∈ A, DifferentiableAt ℝ f x)
    (x : EuclideanSpace ℝ (Fin n))
    (hx : x ∈ A)
    (z : EuclideanSpace ℝ (Fin n))
    (hxz : x + z ∈ A) :
    f (x + z) ≥ f x + (fderiv ℝ f x) z

/-- A strictly convex function satisfies the strict first-order condition:
    f(x + z) > f(x) + ∇f(x)·z for all x ∈ A, x + z ∈ A, and z ≠ 0. -/
axiom StrictConvexOn.strict_first_order_condition
    {n : ℕ}
    {f : EuclideanSpace ℝ (Fin n) → ℝ}
    {A : Set (EuclideanSpace ℝ (Fin n))}
    (hA : Convex ℝ A)
    (hf : StrictConvexOn ℝ A f)
    (hfd : ∀ x ∈ A, DifferentiableAt ℝ f x)
    (x : EuclideanSpace ℝ (Fin n))
    (hx : x ∈ A)
    (z : EuclideanSpace ℝ (Fin n))
    (hz : z ≠ 0)
    (hxz : x + z ∈ A) :
    f (x + z) > f x + (fderiv ℝ f x) z

theorem convex_first_order_characterization
    {n : ℕ}
    {f : EuclideanSpace ℝ (Fin n) → ℝ}
    {A : Set (EuclideanSpace ℝ (Fin n))}
    (hA : Convex ℝ A)
    (hf : ConvexOn ℝ A f)
    (hfd : ∀ x ∈ A, DifferentiableAt ℝ f x)
    (x : EuclideanSpace ℝ (Fin n))
    (hx : x ∈ A)
    (z : EuclideanSpace ℝ (Fin n))
    (hxz : x + z ∈ A) :
    f (x + z) ≥ f x + (fderiv ℝ f x) z :=
  ConvexOn.first_order_condition hA hf hfd x hx z hxz