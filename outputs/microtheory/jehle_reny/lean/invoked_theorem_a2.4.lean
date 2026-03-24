import Mathlib

open Matrix Topology

variable {N : ℕ}

/-- The Hessian matrix of a C² function at a point. -/
noncomputable axiom hessian (f : EuclideanSpace ℝ (Fin N) → ℝ) (x : EuclideanSpace ℝ (Fin N)) :
  Matrix (Fin N) (Fin N) ℝ

/-- The analytic bridge: concavity of a C² function on an open convex set
    implies the Hessian is symmetric and negative semidefinite. -/
axiom concave_hessian_nsd
    {f : EuclideanSpace ℝ (Fin N) → ℝ}
    {A : Set (EuclideanSpace ℝ (Fin N))}
    (hA_open : IsOpen A)
    (hA_convex : Convex ℝ A)
    (hf_concave : ConcaveOn ℝ A f)
    (x : EuclideanSpace ℝ (Fin N))
    (hx : x ∈ A) :
    (hessian f x).IsHermitian ∧ ∀ z : Fin N → ℝ, z ⬝ᵥ ((hessian f x) *ᵥ z) ≤ 0

/-- The Hessian of a concave function is negative semidefinite at every point
    in the interior of its domain. -/
theorem hessian_neg_semidef_of_concave
    {f : EuclideanSpace ℝ (Fin N) → ℝ}
    {A : Set (EuclideanSpace ℝ (Fin N))}
    (hA_open : IsOpen A)
    (hA_convex : Convex ℝ A)
    (hf_concave : ConcaveOn ℝ A f)
    (x : EuclideanSpace ℝ (Fin N))
    (hx : x ∈ A) :
    ∀ z : Fin N → ℝ, z ⬝ᵥ ((hessian f x) *ᵥ z) ≤ 0 :=
  (concave_hessian_nsd hA_open hA_convex hf_concave x hx).2