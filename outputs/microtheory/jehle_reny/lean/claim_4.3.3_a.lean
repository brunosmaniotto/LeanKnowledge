import Mathlib

open MeasureTheory

noncomputable section

theorem claim_4_3_3_a
    (p mc : ℝ → ℝ) (tvc q : ℝ)
    (h_tvc : tvc = ∫ ξ in (0:ℝ)..q, mc ξ)
    (hp : IntervalIntegrable p volume 0 q)
    (hmc : IntervalIntegrable mc volume 0 q)
    : ((∫ ξ in (0:ℝ)..q, p ξ) - p q * q) + (p q * q - tvc) =
      ∫ ξ in (0:ℝ)..q, (p ξ - mc ξ) := by
  rw [h_tvc, intervalIntegral.integral_sub hp hmc]
  ring