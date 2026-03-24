import Mathlib

open intervalIntegral

theorem Claim_9_8_VCG_revenue :
    (∫ t_b in (0:ℝ)..1, (1/2 : ℝ) * t_b ^ 2) + (∫ t_s in (0:ℝ)..1, (1/2 : ℝ) * t_s ^ 2) = (1/3 : ℝ) := by
  rw [show (∫ t_s in (0:ℝ)..1, (1/2 : ℝ) * t_s ^ 2) = ∫ t_b in (0:ℝ)..1, (1/2 : ℝ) * t_b ^ 2 by rfl]
  calc
    (∫ t_b in (0:ℝ)..1, (1/2 : ℝ) * t_b ^ 2) + (∫ t_b in (0:ℝ)..1, (1/2 : ℝ) * t_b ^ 2) = 
        2 * (∫ t_b in (0:ℝ)..1, (1/2 : ℝ) * t_b ^ 2) := by ring
    _ = 2 * ((1/2 : ℝ) * (∫ t_b in (0:ℝ)..1, t_b ^ 2)) := by rw [integral_const_mul]
    _ = (2 * (1/2 : ℝ)) * (∫ t_b in (0:ℝ)..1, t_b ^ 2) := by ring
    _ = 1 * (∫ t_b in (0:ℝ)..1, t_b ^ 2) := by norm_num
    _ = ∫ t_b in (0:ℝ)..1, t_b ^ 2 := by simp
    _ = (1 ^ (2 + 1 : ℕ) - 0 ^ (2 + 1 : ℕ)) / ((2 : ℕ) + 1 : ℝ) := by rw [integral_pow 2]
    _ = (1 - 0) / (3 : ℝ) := by norm_num
    _ = (1/3 : ℝ) := by norm_num