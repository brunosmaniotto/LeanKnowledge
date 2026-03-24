import Mathlib
open Topology

axiom MWG.quasiconcave_hessian_iff
    {n : ℕ} {A : Set (EuclideanSpace ℝ (Fin n))}
    (hA : Convex ℝ A)
    (f : EuclideanSpace ℝ (Fin n) → ℝ)
    (hf : ContDiff ℝ 2 f) :
    QuasiconcaveOn ℝ A f ↔
    ∀ x ∈ A, ∀ z : EuclideanSpace ℝ (Fin n),
      fderiv ℝ f x z = 0 →
      fderiv ℝ (fun v => fderiv ℝ f v z) x z ≤ 0

axiom MWG.quasiconvexOn_iff_neg_quasiconcaveOn
    {n : ℕ} {A : Set (EuclideanSpace ℝ (Fin n))}
    (f : EuclideanSpace ℝ (Fin n) → ℝ) :
    QuasiconvexOn ℝ A f ↔ QuasiconcaveOn ℝ A (-f)

axiom MWG.fderiv_neg_apply_eq
    {n : ℕ} (f : EuclideanSpace ℝ (Fin n) → ℝ)
    (x z : EuclideanSpace ℝ (Fin n)) :
    fderiv ℝ (fun v => fderiv ℝ (-f) v z) x z =
    -fderiv ℝ (fun v => fderiv ℝ f v z) x z

theorem MWG.quasiconvex_hessian_condition
    {n : ℕ} {A : Set (EuclideanSpace ℝ (Fin n))}
    (hA : Convex ℝ A)
    (f : EuclideanSpace ℝ (Fin n) → ℝ)
    (hf : ContDiff ℝ 2 f) :
    QuasiconvexOn ℝ A f ↔
    ∀ x ∈ A, ∀ z : EuclideanSpace ℝ (Fin n),
      fderiv ℝ f x z = 0 →
      fderiv ℝ (fun v => fderiv ℝ f v z) x z ≥ 0 := by
  rw [MWG.quasiconvexOn_iff_neg_quasiconcaveOn,
      MWG.quasiconcave_hessian_iff hA (-f) hf.neg]
  constructor
  · intro h x hx z hgrad
    have hg : (fderiv ℝ (-f) x) z = 0 := by
      rw [fderiv_neg]; simp [hgrad]
    have h' := h x hx z hg
    rw [MWG.fderiv_neg_apply_eq] at h'
    linarith
  · intro h x hx z hgrad
    have hg : (fderiv ℝ f x) z = 0 := by
      have : (fderiv ℝ (-f) x) z = -(fderiv ℝ f x) z := by
        rw [fderiv_neg]; simp
      linarith [this]
    have h' := h x hx z hg
    rw [MWG.fderiv_neg_apply_eq]
    linarith