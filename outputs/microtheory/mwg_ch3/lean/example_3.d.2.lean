import Mathlib

open Real

theorem Example_3D2
    (α w p₁ p₂ : ℝ)
    (hα₀ : 0 < α) (hα₁ : α < 1)
    (hw : 0 < w) (hp₁ : 0 < p₁) (hp₂ : 0 < p₂) :
    α * log (α * w / p₁) + (1 - α) * log ((1 - α) * w / p₂) =
    (α * log α + (1 - α) * log (1 - α)) + log w - α * log p₁ - (1 - α) * log p₂ := by
  have hα' : 0 < 1 - α := by linarith
  have hαw : 0 < α * w := mul_pos hα₀ hw
  have hα'w : 0 < (1 - α) * w := mul_pos hα' hw
  rw [div_eq_mul_inv (α * w) p₁, div_eq_mul_inv ((1 - α) * w) p₂]
  rw [log_mul (ne_of_gt hαw) (ne_of_gt (inv_pos.mpr hp₁))]
  rw [log_mul (ne_of_gt hα'w) (ne_of_gt (inv_pos.mpr hp₂))]
  rw [log_mul (ne_of_gt hα₀) (ne_of_gt hw)]
  rw [log_mul (ne_of_gt hα') (ne_of_gt hw)]
  rw [log_inv, log_inv]
  ring