import Mathlib

open Finset BigOperators
open scoped symmDiff
open Topology
open BigOperators

theorem uld_of_neg_definite_derivative
    {n : ℕ}
    (Dp : Matrix (Fin n) (Fin n) ℝ)
    (h_neg_def : ∀ v : Fin n → ℝ, v ≠ 0 →
      ∑ i : Fin n, ∑ j : Fin n, v i * Dp i j * v j < 0)
    (Δp : Fin n → ℝ)
    (hΔp : Δp ≠ 0) :
    ∑ i : Fin n, Δp i * (Dp.mulVec Δp) i < 0 := by
  have key := h_neg_def Δp hΔp
  suffices h : ∑ i, Δp i * (Dp.mulVec Δp) i = ∑ i, ∑ j, Δp i * Dp i j * Δp j by linarith
  apply Finset.sum_congr rfl; intro i _
  simp only [Matrix.mulVec, dotProduct, Finset.mul_sum]
  apply Finset.sum_congr rfl; intro j _
  ring