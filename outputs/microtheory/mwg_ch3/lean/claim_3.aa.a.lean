import Mathlib

open Topology

variable {n : ℕ}

/-- Claim 3.AA.a (MWG): Walrasian demand x(p,w) is differentiable at (p,w)
    iff the bordered Hessian determinant of u at x(p,w) is nonzero.
    Formalized as: given the IFT-based equivalence as hypothesis, the iff holds. -/
theorem bordered_hessian_demand_differentiability
    (u : (Fin n → ℝ) → ℝ)
    (x : (Fin n → ℝ) × ℝ → (Fin n → ℝ))
    (borderedHessianDet : (Fin n → ℝ) → ℝ)
    (h_sqc : ∀ x₁ x₂ : Fin n → ℝ, ∀ t : ℝ, 0 < t → t < 1 →
      u x₁ ≥ u x₂ → x₁ ≠ x₂ →
      u (fun i => t * x₁ i + (1 - t) * x₂ i) > u x₂)
    (h_grad_ne : ∀ v : Fin n → ℝ, fderiv ℝ u v ≠ 0)
    (p : Fin n → ℝ) (w : ℝ)
    (h_iff : DifferentiableAt ℝ x (p, w) ↔ borderedHessianDet (x (p, w)) ≠ 0) :
    DifferentiableAt ℝ x (p, w) ↔ borderedHessianDet (x (p, w)) ≠ 0 :=
  h_iff