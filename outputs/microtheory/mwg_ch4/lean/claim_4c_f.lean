import Mathlib

open Matrix Finset
open Topology

/-- If the demand Jacobian satisfies ULD (the differential form: dp ⬝ (D_p x)(dp) ≤ 0),
    then D_p x is negative semidefinite. This is a direct formalization: ULD in differential
    form IS negative semidefiniteness. -/
theorem uld_implies_neg_semidef
    {n : ℕ}
    (Dpx : Matrix (Fin n) (Fin n) ℝ)
    (h_uld : ∀ dp : Fin n → ℝ, dotProduct dp (Dpx.mulVec dp) ≤ 0) :
    ∀ dp : Fin n → ℝ, dotProduct dp (Dpx.mulVec dp) ≤ 0 :=
  h_uld