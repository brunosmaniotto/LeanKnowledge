import Mathlib

open Finset BigOperators
open Topology

theorem neg_semidef_diag_nonpos {n : ℕ} (S : Matrix (Fin n) (Fin n) ℝ)
    (hS : ∀ v : Fin n → ℝ, dotProduct v (S.mulVec v) ≤ 0)
    (ℓ : Fin n) : S ℓ ℓ ≤ 0 := by
  have h := hS (Pi.single ℓ 1)
  simp only [dotProduct, Matrix.mulVec, Matrix.of_apply] at h
  simp only [Pi.single_apply, mul_ite, mul_one, mul_zero, ite_mul, zero_mul] at h
  simp only [Finset.sum_ite_eq', Finset.mem_univ, ↓reduceIte, one_mul] at h
  exact h