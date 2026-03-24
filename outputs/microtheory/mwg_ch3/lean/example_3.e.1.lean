import Mathlib

open Real

theorem Example_3_E_1
    (α : ℝ) (hα₀ : 0 < α) (hα₁ : α < 1)
    (p₁ p₂ u : ℝ) (hp₁ : 0 < p₁) (hp₂ : 0 < p₂) (hu : 0 < u) :
    (((1 - α) * p₂ / (α * p₁)) ^ (1 - α) * u) ^ α *
    ((α * p₁ / ((1 - α) * p₂)) ^ α * u) ^ (1 - α) = u := by
  have hα₁' : 0 < 1 - α := by linarith
  have hαp₁ : 0 < α * p₁ := mul_pos hα₀ hp₁
  have h1αp₂ : 0 < (1 - α) * p₂ := mul_pos hα₁' hp₂
  have hr₁ : 0 < (1 - α) * p₂ / (α * p₁) := div_pos h1αp₂ hαp₁
  have hr₂ : 0 < α * p₁ / ((1 - α) * p₂) := div_pos hαp₁ h1αp₂
  have hlhs_pos : 0 < (((1 - α) * p₂ / (α * p₁)) ^ (1 - α) * u) ^ α *
    ((α * p₁ / ((1 - α) * p₂)) ^ α * u) ^ (1 - α) := by positivity
  rw [← Real.log_injOn_pos.eq_iff (Set.mem_Ioi.mpr hlhs_pos) (Set.mem_Ioi.mpr hu)]
  rw [Real.log_mul (ne_of_gt (by positivity)) (ne_of_gt (by positivity))]
  rw [Real.log_rpow (by positivity : 0 < ((1 - α) * p₂ / (α * p₁)) ^ (1 - α) * u)]
  rw [Real.log_rpow (by positivity : 0 < (α * p₁ / ((1 - α) * p₂)) ^ α * u)]
  rw [Real.log_mul (ne_of_gt (rpow_pos_of_pos hr₁ _)) (ne_of_gt hu)]
  rw [Real.log_mul (ne_of_gt (rpow_pos_of_pos hr₂ _)) (ne_of_gt hu)]
  rw [Real.log_rpow hr₁]
  rw [Real.log_rpow hr₂]
  have hrecip : α * p₁ / ((1 - α) * p₂) = ((1 - α) * p₂ / (α * p₁))⁻¹ := by
    rw [inv_div]
  rw [hrecip, Real.log_inv]
  ring