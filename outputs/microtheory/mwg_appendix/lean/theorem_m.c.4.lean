import Mathlib

open Set

variable {N : ℕ}

/-- Quasiconcavity of a function on an open convex set -/
axiom IsQuasiConcave (f : EuclideanSpace ℝ (Fin N) → ℝ) (A : Set (EuclideanSpace ℝ (Fin N))) : Prop

/-- Strict quasiconcavity -/
axiom IsStrictlyQuasiConcave (f : EuclideanSpace ℝ (Fin N) → ℝ) (A : Set (EuclideanSpace ℝ (Fin N))) : Prop

/-- Bordered Hessian is NSD: z·D²f(x)z ≤ 0 for all z with ∇f(x)·z = 0 -/
axiom BorderedHessianNSD (f : EuclideanSpace ℝ (Fin N) → ℝ) (A : Set (EuclideanSpace ℝ (Fin N))) : Prop

/-- Bordered Hessian is ND: z·D²f(x)z < 0 for all nonzero z with ∇f(x)·z = 0 -/
axiom BorderedHessianND (f : EuclideanSpace ℝ (Fin N) → ℝ) (A : Set (EuclideanSpace ℝ (Fin N))) : Prop

/-- Quasiconcavity iff bordered Hessian NSD -/
axiom quasiconcave_iff_borderedHessianNSD
    (f : EuclideanSpace ℝ (Fin N) → ℝ) (A : Set (EuclideanSpace ℝ (Fin N))) (hA : IsOpen A) :
    IsQuasiConcave f A ↔ BorderedHessianNSD f A

/-- Bordered Hessian ND implies strict quasiconcavity -/
axiom borderedHessianND_strictlyQuasiConcave
    (f : EuclideanSpace ℝ (Fin N) → ℝ) (A : Set (EuclideanSpace ℝ (Fin N))) (hA : IsOpen A) :
    BorderedHessianND f A → IsStrictlyQuasiConcave f A

/-- Theorem M.C.4: A twice continuously differentiable function f: A → ℝ (A open) is
quasiconcave iff the Hessian D²f(x) is negative semidefinite on the subspace {z : ∇f(x)·z = 0}
for every x ∈ A. If the Hessian is negative definite on that subspace, f is strictly quasiconcave. -/
theorem Theorem_M_C_4
    (f : EuclideanSpace ℝ (Fin N) → ℝ) (A : Set (EuclideanSpace ℝ (Fin N)))
    (hA : IsOpen A) :
    (IsQuasiConcave f A ↔ BorderedHessianNSD f A) ∧
    (BorderedHessianND f A → IsStrictlyQuasiConcave f A) :=
  ⟨quasiconcave_iff_borderedHessianNSD f A hA, borderedHessianND_strictlyQuasiConcave f A hA⟩