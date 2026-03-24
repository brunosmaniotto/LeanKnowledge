import Mathlib

open Real
open Topology

theorem Claim_Ex1_2_d
    (p₁ p₂ y pᵢ r : ℝ)
    (hr : r ≠ 0)
    (hS : 0 < p₁ ^ r + p₂ ^ r) :
    (-1) * (-((p₁ ^ r + p₂ ^ r) ^ (-1 / r - 1) * y * pᵢ ^ (r - 1))) /
      (p₁ ^ r + p₂ ^ r) ^ (-1 / r) =
    y * pᵢ ^ (r - 1) / (p₁ ^ r + p₂ ^ r) := by
  set S := p₁ ^ r + p₂ ^ r
  have hS_ne : S ≠ 0 := hS.ne'
  have hrpow : S ^ ((-1 : ℝ) / r) ≠ 0 := (rpow_pos_of_pos hS _).ne'
  have hsign : (-1 : ℝ) * (-(S ^ (-1 / r - 1) * y * pᵢ ^ (r - 1))) =
      S ^ (-1 / r - 1) * y * pᵢ ^ (r - 1) := by ring
  rw [hsign, div_eq_div_iff hrpow hS_ne]
  -- Key: S^{-1/r - 1} * S = S^{-1/r - 1 + 1} = S^{-1/r}
  have key : S ^ ((-1 : ℝ) / r - 1) * S = S ^ ((-1 : ℝ) / r) := by
    have h := rpow_add hS ((-1 : ℝ) / r - 1) 1
    rw [rpow_one] at h
    rw [show (-1 : ℝ) / r - 1 + 1 = (-1 : ℝ) / r from by ring] at h
    exact h.symm
  rw [← key]; ring