import Mathlib

open Real

/-- All CES production functions are homogeneous of degree 1:
    f(t·z₁, t·z₂) = t · f(z₁, z₂) for t > 0. -/
theorem Claim_3_2_n
    (α : ℝ) (hα₀ : 0 < α) (hα₁ : α < 1)
    (ρ : ℝ) (hρ : ρ ≠ 0)
    (z₁ z₂ : ℝ) (hz₁ : 0 < z₁) (hz₂ : 0 < z₂)
    (t : ℝ) (ht : 0 < t) :
    (α * (t * z₁) ^ ρ + (1 - α) * (t * z₂) ^ ρ) ^ (1 / ρ) =
    t * (α * z₁ ^ ρ + (1 - α) * z₂ ^ ρ) ^ (1 / ρ) := by
  have ht_nn := le_of_lt ht
  have hz₁_nn := le_of_lt hz₁
  have hz₂_nn := le_of_lt hz₂
  -- (t * zᵢ)^ρ = t^ρ * zᵢ^ρ
  rw [mul_rpow ht_nn hz₁_nn, mul_rpow ht_nn hz₂_nn]
  -- Factor t^ρ out of the weighted sum
  have h_factor : α * (t ^ ρ * z₁ ^ ρ) + (1 - α) * (t ^ ρ * z₂ ^ ρ) =
      t ^ ρ * (α * z₁ ^ ρ + (1 - α) * z₂ ^ ρ) := by ring
  rw [h_factor]
  -- Split (t^ρ * S)^(1/ρ) = (t^ρ)^(1/ρ) * S^(1/ρ)
  rw [mul_rpow (le_of_lt (rpow_pos_of_pos ht ρ))
    (add_nonneg (mul_nonneg (le_of_lt hα₀) (le_of_lt (rpow_pos_of_pos hz₁ ρ)))
               (mul_nonneg (by linarith) (le_of_lt (rpow_pos_of_pos hz₂ ρ))))]
  -- Reduce to showing (t^ρ)^(1/ρ) = t
  congr 1
  rw [← rpow_mul ht_nn]
  have : ρ * (1 / ρ) = 1 := by field_simp
  rw [this, rpow_one]