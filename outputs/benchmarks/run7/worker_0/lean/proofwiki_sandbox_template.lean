import Mathlib

open Real

theorem zeta_four_eq : ∑' n : ℕ, 1 / ((n : ℝ) ^ 4) = π ^ 4 / 90 :=
  hasSum_zeta_four.tsum_eq