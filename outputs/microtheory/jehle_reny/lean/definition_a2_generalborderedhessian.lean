import Mathlib

open Matrix
open Topology

/-- The bordered Hessian for a constrained optimisation problem with `n` variables
    and `m < n` equality constraints. Given the constraint Jacobian `G` (m × n matrix
    of ∂gʲ/∂xᵢ) and the Lagrangian Hessian `L` (n × n matrix of ∂²L/∂xᵢ∂xⱼ),
    the bordered Hessian is the (m + n) × (m + n) symmetric block matrix
    ⎡ 0   G ⎤
    ⎣ Gᵀ  L ⎦ -/
noncomputable def MWG.GeneralBorderedHessian
    {m n : ℕ}
    (G : Matrix (Fin m) (Fin n) ℝ)
    (L : Matrix (Fin n) (Fin n) ℝ) :
    Matrix (Fin (m + n)) (Fin (m + n)) ℝ :=
  (fromBlocks (0 : Matrix (Fin m) (Fin m) ℝ) G Gᵀ L).submatrix
    finSumFinEquiv.symm finSumFinEquiv.symm