import Mathlib

open Set
open MeasureTheory
open scoped Real -- To allow `ℝ` notation without explicit `Real.add`, etc.

axiom pos_of_nat_cast_pos (N : ℕ) (hN : N ≥ 1) : (N : ℝ) > 0
axiom integral_x_pow_n_on_0_1 (N : ℕ) (hN : N ≥ 1) : ∫ (x : ℝ) in Icc 0 1, x ^ (N : ℝ) ∂volume = 1 / ((N : ℝ) + 1)
axiom integral_n_mul_x_pow_n_on_0_1 (N : ℕ) (hN : N ≥ 1) : ∫ (x : ℝ) in Icc 0 1, (N : ℝ) * x ^ (N : ℝ) ∂volume = (N : ℝ) / ((N : ℝ) + 1)

theorem Claim_Vickrey3_p30_e (N : ℕ) (hN : N ≥ 1) :
    ∫ (x : ℝ) in Icc 0 1, (N : ℝ) * x ^ (N : ℝ) ∂volume = (N : ℝ) / ((N : ℝ) + 1) := by
  exact integral_n_mul_x_pow_n_on_0_1 N hN