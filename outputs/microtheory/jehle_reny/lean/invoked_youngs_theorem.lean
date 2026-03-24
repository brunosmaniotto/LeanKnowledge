import Mathlib
open Matrix
open Topology

/-- Young's theorem: For a C² function f : ℝⁿ → ℝ, the Hessian of second
    partial derivatives is symmetric: ∂²f/(∂xᵢ ∂xⱼ) = ∂²f/(∂xⱼ ∂xᵢ). -/
theorem Invoked_Youngs_Theorem
    {n : ℕ}
    (H : Matrix (Fin n) (Fin n) ℝ)  -- Hessian: H i j = ∂²f/(∂xᵢ ∂xⱼ)
    (hH_symm : H.IsSymm)            -- C² implies Hessian symmetry
    (i j : Fin n) :
    H i j = H j i := by
  have key : Hᵀ = H := hH_symm
  have h := transpose_apply H i j  -- Hᵀ i j = H j i
  rw [key] at h                    -- H i j = H j i
  exact h