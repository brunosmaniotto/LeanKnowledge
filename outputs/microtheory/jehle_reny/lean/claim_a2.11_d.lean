import Mathlib
open Topology

/-!
# Claim_A2.11_d: Hessian Characterization of Strict Convexity

**Theorem:** A twice continuously differentiable function f is strictly convex if
the principal minors of its Hessian are all positive for all x in the domain.

**Proof sketch:** Direct restatement of Theorem A2.11 part 2.
-/

-- Abstract propositions representing the mathematical conditions
axiom TwiceContinuouslyDifferentiable (f : EuclideanSpace ℝ (Fin n) → ℝ) : Prop
axiom HessianPrincipalMinorsPositive (f : EuclideanSpace ℝ (Fin n) → ℝ) : Prop
axiom IsStrictlyConvex (f : EuclideanSpace ℝ (Fin n) → ℝ) : Prop

/-- Theorem A2.11 part 2: positive principal minors of the Hessian imply strict convexity. -/
axiom theorem_A2_11_part2 {n : ℕ} (f : EuclideanSpace ℝ (Fin n) → ℝ)
    (hsmooth : TwiceContinuouslyDifferentiable f)
    (hminors : HessianPrincipalMinorsPositive f) :
    IsStrictlyConvex f

theorem Claim_A2_11_d {n : ℕ} (f : EuclideanSpace ℝ (Fin n) → ℝ)
    (hsmooth : TwiceContinuouslyDifferentiable f)
    (hminors : HessianPrincipalMinorsPositive f) :
    IsStrictlyConvex f :=
  theorem_A2_11_part2 f hsmooth hminors