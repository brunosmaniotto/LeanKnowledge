import Mathlib

open Matrix Finset BigOperators
open Topology

variable {n : ℕ}

def IsNegSemidef (A : Matrix (Fin n) (Fin n) ℝ) : Prop :=
  ∀ v : Fin n → ℝ, dotProduct v (A.mulVec v) ≤ 0

axiom expenditure_concave :
  ∀ (e : (Fin n → ℝ) → ℝ) (hessian_e : Matrix (Fin n) (Fin n) ℝ),
    IsNegSemidef hessian_e

axiom substitution_matrix_eq_hessian :
  ∀ (σ hessian_e : Matrix (Fin n) (Fin n) ℝ), σ = hessian_e