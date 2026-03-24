import Mathlib

open Matrix
open Topology

variable {n : ℕ}

/-- Theorem 1.14: Symmetry of the Substitution Matrix.
    Cross-substitution effects of Hicksian demands are symmetric:
    ∂xᵢʰ/∂pⱼ = ∂xⱼʰ/∂pᵢ. This follows from Shephard's lemma
    (Theorem 1.12, giving xᵢʰ = ∂e/∂pᵢ) and Young's theorem
    (mixed partials of C² functions commute). -/
theorem Theorem_1_14
    -- Hessian of the expenditure function e(·, u) at price vector p
    (H : Matrix (Fin n) (Fin n) ℝ)
    -- Cross-price derivatives: dx i j = ∂xᵢʰ(p,u)/∂pⱼ
    (dx : Fin n → Fin n → ℝ)
    -- Shephard's lemma differentiated: ∂xᵢʰ/∂pⱼ = ∂²e/(∂pⱼ∂pᵢ) = H(j,i)
    (shephards_diff : ∀ i j, dx i j = H j i)
    -- Young's theorem: C² expenditure function ⟹ symmetric Hessian
    (hessian_symm : H.IsSymm) :
    ∀ i j, dx i j = dx j i := by
  intro i j
  rw [shephards_diff i j, shephards_diff j i]
  -- Goal: H j i = H i j, which is Hessian symmetry
  exact (transpose_apply H i j).symm.trans (congr_fun (congr_fun hessian_symm i) j)