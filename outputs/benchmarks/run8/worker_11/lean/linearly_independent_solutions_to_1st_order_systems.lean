import Mathlib

open Matrix
open BigOperators

-- Axiom: Global existence and uniqueness for the linear ODE system x' = A(t)x
axiom global_exists_unique_solution {n : ℕ} (A : ℝ → Matrix (Fin n) (Fin n) ℝ) 
  (hA : Continuous A) (t₀ : ℝ) (x₀ : Fin n → ℝ) :
  ∃! φ : ℝ → (Fin n → ℝ), (∀ t, HasDerivAt φ (Matrix.mulVec (A t) (φ t)) t) ∧ φ t₀ = x₀

-- Definition of being a solution to the system
def IsSolution {n : ℕ} (A : ℝ → Matrix (Fin n) (Fin n) ℝ) (x : ℝ → (Fin n → ℝ)) : Prop :=
  ∀ t, HasDerivAt x (Matrix.mulVec (A t) (x t)) t

-- Standard basis vectors in ℝⁿ
noncomputable def stdBasis {n : ℕ} (i : Fin n) : Fin n → ℝ :=
  fun j => if i = j then 1 else 0