import Mathlib

open Real

noncomputable def cobbDouglas (α β : ℝ) (z₁ z₂ : ℝ) : ℝ :=
  z₁ ^ α * z₂ ^ β

theorem Example_5B3 (α β : ℝ) (z₁ z₂ t : ℝ) (hz₁ : 0 < z₁) (hz₂ : 0 < z₂) (ht : 0 < t) :
    cobbDouglas α β (t * z₁) (t * z₂) = t ^ (α + β) * cobbDouglas α β z₁ z₂ := by
  unfold cobbDouglas
  rw [mul_rpow (le_of_lt ht) (le_of_lt hz₁), mul_rpow (le_of_lt ht) (le_of_lt hz₂)]
  rw [rpow_add ht]
  ring