import Mathlib

open Real

theorem Claim_5_2_d
    (α β T : ℝ)
    (hα₀ : 0 < α) (hα₁ : α < 1)
    (hβ₀ : 0 < β) (hβ₁ : β < 1)
    (hT : 0 < T) :
    let w_star := α * ((1 - β * (1 - α)) / (α * β * T)) ^ (1 - α)
    0 < w_star := by
  simp only
  have h1mα : 0 < 1 - α := by linarith
  have hbeta_prod : β * (1 - α) < 1 := by nlinarith
  have hnum : 0 < 1 - β * (1 - α) := by linarith
  have hden : 0 < α * β * T := by positivity
  have hbase : 0 < (1 - β * (1 - α)) / (α * β * T) := div_pos hnum hden
  exact mul_pos hα₀ (rpow_pos_of_pos hbase _)