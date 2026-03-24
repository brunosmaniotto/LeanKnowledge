import Mathlib

open Finset BigOperators
open Topology
open BigOperators

theorem claim_6F_b {N : ℕ} (hN : 0 < N) (u : Fin N → ℝ → ℝ) (x y : ℝ) :
    ∑ i : Fin N, (1 / (N : ℝ)) * u i x > ∑ i : Fin N, (1 / (N : ℝ)) * u i y ↔
    ∑ i : Fin N, u i x > ∑ i : Fin N, u i y := by
  have hNr : (0 : ℝ) < (N : ℝ) := Nat.cast_pos.mpr hN
  have hc : (0 : ℝ) < 1 / (N : ℝ) := div_pos one_pos hNr
  simp only [← Finset.mul_sum]
  constructor
  · intro h
    by_contra hle
    push_neg at hle
    linarith [mul_le_mul_of_nonneg_left hle hc.le]
  · exact fun h => mul_lt_mul_of_pos_left h hc