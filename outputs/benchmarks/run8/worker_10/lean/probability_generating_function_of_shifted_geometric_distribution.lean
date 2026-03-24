import Mathlib

open Real
open Topology

theorem shifted_geometric_pgf (p s : ℝ) (hp : 0 < p) (hp' : p ≤ 1) (h : ‖(1 - p) * s‖ < 1) :
    ∑' k : ℕ, p * (1 - p) ^ k * s ^ (k + 1) = (p * s) / (1 - (1 - p) * s) := by
  have hsum : ∑' n : ℕ, ((1 - p) * s) ^ n = (1 - (1 - p) * s)⁻¹ :=
    tsum_geometric_of_norm_lt_one h
  calc
    ∑' k : ℕ, p * (1 - p) ^ k * s ^ (k + 1) = ∑' k : ℕ, (p * s) * (((1 - p) * s) ^ k) := by
      refine tsum_congr fun k => ?_
      calc
        p * (1 - p) ^ k * s ^ (k + 1) = p * (1 - p) ^ k * (s ^ k * s) := by rw [pow_succ]
        _ = p * ((1 - p) ^ k * s ^ k) * s := by ring
        _ = p * (((1 - p) * s) ^ k) * s := by rw [mul_pow]
        _ = (p * s) * (((1 - p) * s) ^ k) := by ring
    _ = (p * s) * ∑' k : ℕ, ((1 - p) * s) ^ k := by rw [tsum_mul_left]
    _ = (p * s) * (1 - (1 - p) * s)⁻¹ := by rw [hsum]
    _ = (p * s) / (1 - (1 - p) * s) := by rw [div_eq_mul_inv]