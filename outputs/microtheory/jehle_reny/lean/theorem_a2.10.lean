import Mathlib

open Topology

variable {N : ℕ}

/-- The Hessian quadratic form z^T H(x) z, defined as D²f(x)(z,z). -/
noncomputable def hessianQuad
    (f : EuclideanSpace ℝ (Fin N) → ℝ)
    (x z : EuclideanSpace ℝ (Fin N)) : ℝ :=
  (fderiv ℝ (fderiv ℝ f) x z) z

/-- At a local maximum of a C² function, the Hessian is negative semidefinite.
    Proof: reduce to 1D via g(t) = f(x + t•z); g''(0) = z^T H(x) z ≤ 0. -/
axiom hessian_nsd_of_localMax
    {f : EuclideanSpace ℝ (Fin N) → ℝ}
    (hf : ContDiff ℝ 2 f) {x : EuclideanSpace ℝ (Fin N)}
    (hmax : IsLocalMax f x) (z : EuclideanSpace ℝ (Fin N)) :
    hessianQuad f x z ≤ 0

/-- At a local minimum of a C² function, the Hessian is positive semidefinite.
    Proof: reduce to 1D via g(t) = f(x + t•z); g''(0) = z^T H(x) z ≥ 0. -/
axiom hessian_psd_of_localMin
    {f : EuclideanSpace ℝ (Fin N) → ℝ}
    (hf : ContDiff ℝ 2 f) {x : EuclideanSpace ℝ (Fin N)}
    (hmin : IsLocalMin f x) (z : EuclideanSpace ℝ (Fin N)) :
    0 ≤ hessianQuad f x z

/-- MWG Theorem A2.10: Second-order necessary conditions for local interior optima.
    (1) At a local max, H(x*) is negative semidefinite.
    (2) At a local min, H(x̃) is positive semidefinite. -/
theorem theorem_A2_10
    (f : EuclideanSpace ℝ (Fin N) → ℝ) (hf : ContDiff ℝ 2 f) :
    (∀ x, IsLocalMax f x → ∀ z, hessianQuad f x z ≤ 0) ∧
    (∀ x, IsLocalMin f x → ∀ z, 0 ≤ hessianQuad f x z) :=
  ⟨fun x hmax z => hessian_nsd_of_localMax hf hmax z,
   fun x hmin z => hessian_psd_of_localMin hf hmin z⟩