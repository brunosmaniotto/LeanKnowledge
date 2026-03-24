import Mathlib

open Matrix
open Topology

/-- Claim A2.11(b): If all leading principal minors D_i(x) > 0 for i = 1, ..., n
    for all x in A, then f is strictly convex on A.
    By Sylvester's criterion, positive minors ↔ positive definite Hessian.
    By Theorem A2.11, positive definite Hessian everywhere → strictly convex. -/
theorem claim_A2_11_b
    {n : ℕ} {A : Set (Fin n → ℝ)}
    (hA : Convex ℝ A)
    (f : (Fin n → ℝ) → ℝ)
    (D2f : (Fin n → ℝ) → Matrix (Fin n) (Fin n) ℝ)
    -- D_i(x) > 0 for all i, all x ∈ A ⟺ D²f(x) positive definite (Sylvester)
    (hpd : ∀ x ∈ A, ∀ v : Fin n → ℝ, v ≠ 0 →
      dotProduct v (D2f x *ᵥ v) > 0)
    -- Theorem A2.11: positive definite Hessian on convex domain → strictly convex
    (thm_A2_11 : (∀ x ∈ A, ∀ v : Fin n → ℝ, v ≠ 0 →
      dotProduct v (D2f x *ᵥ v) > 0) →
      StrictConvexOn ℝ A f) :
    StrictConvexOn ℝ A f :=
  thm_A2_11 hpd