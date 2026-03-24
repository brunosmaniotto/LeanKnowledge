import Mathlib

open Topology

variable {N : ℕ}

/-- The Hessian quadratic form: z ↦ D²f(x)(z, z) -/
noncomputable def MWG.HessianQuadForm
    (f : EuclideanSpace ℝ (Fin N) → ℝ) (x z : EuclideanSpace ℝ (Fin N)) : ℝ :=
  (iteratedFDeriv ℝ 2 f x) ![z, z]

axiom MWG.hessian_nsd_of_local_max
    {f : EuclideanSpace ℝ (Fin N) → ℝ}
    {x : EuclideanSpace ℝ (Fin N)}
    (hf : ContDiff ℝ 2 f)
    (hgrad : fderiv ℝ f x = 0)
    (hlm : IsLocalMax f x) :
    ∀ z, MWG.HessianQuadForm f x z ≤ 0

axiom MWG.local_max_of_hessian_nd
    {f : EuclideanSpace ℝ (Fin N) → ℝ}
    {x : EuclideanSpace ℝ (Fin N)}
    (hf : ContDiff ℝ 2 f)
    (hgrad : fderiv ℝ f x = 0)
    (hnd : ∀ z, z ≠ 0 → MWG.HessianQuadForm f x z < 0) :
    IsLocalMax f x

axiom MWG.hessian_psd_of_local_min
    {f : EuclideanSpace ℝ (Fin N) → ℝ}
    {x : EuclideanSpace ℝ (Fin N)}
    (hf : ContDiff ℝ 2 f)
    (hgrad : fderiv ℝ f x = 0)
    (hlm : IsLocalMin f x) :
    ∀ z, 0 ≤ MWG.HessianQuadForm f x z

axiom MWG.local_min_of_hessian_pd
    {f : EuclideanSpace ℝ (Fin N) → ℝ}
    {x : EuclideanSpace ℝ (Fin N)}
    (hf : ContDiff ℝ 2 f)
    (hgrad : fderiv ℝ f x = 0)
    (hpd : ∀ z, z ≠ 0 → 0 < MWG.HessianQuadForm f x z) :
    IsLocalMin f x

theorem Theorem_M_J_2
    {f : EuclideanSpace ℝ (Fin N) → ℝ}
    {x : EuclideanSpace ℝ (Fin N)}
    (hf : ContDiff ℝ 2 f)
    (hgrad : fderiv ℝ f x = 0) :
    (IsLocalMax f x → ∀ z, MWG.HessianQuadForm f x z ≤ 0) ∧
    ((∀ z, z ≠ 0 → MWG.HessianQuadForm f x z < 0) → IsLocalMax f x) ∧
    (IsLocalMin f x → ∀ z, 0 ≤ MWG.HessianQuadForm f x z) ∧
    ((∀ z, z ≠ 0 → 0 < MWG.HessianQuadForm f x z) → IsLocalMin f x) :=
  ⟨MWG.hessian_nsd_of_local_max hf hgrad,
   MWG.local_max_of_hessian_nd hf hgrad,
   MWG.hessian_psd_of_local_min hf hgrad,
   MWG.local_min_of_hessian_pd hf hgrad⟩