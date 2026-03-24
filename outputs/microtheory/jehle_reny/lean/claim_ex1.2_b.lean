import Mathlib

open Real

/-- For the CES indirect utility function v(p,y) = y·(p₁ʳ+p₂ʳ)^{-1/r},
    ∂v/∂y > 0 (strictly increasing in income) and
    ∂v/∂pᵢ < 0 (decreasing in prices). -/
theorem Claim_Ex1_2_b
    (p₁ p₂ r y : ℝ)
    (hp₁ : p₁ > 0) (hp₂ : p₂ > 0)
    (hr : r ≠ 0)
    (hy : y > 0) :
    let S := p₁ ^ r + p₂ ^ r
    S ^ (-(1 / r)) > 0 ∧
    -(S ^ (-(1 / r) - 1) * y * p₁ ^ (r - 1)) < 0 ∧
    -(S ^ (-(1 / r) - 1) * y * p₂ ^ (r - 1)) < 0 := by
  intro S
  have hS : (0 : ℝ) < S := add_pos (rpow_pos_of_pos hp₁ r) (rpow_pos_of_pos hp₂ r)
  refine ⟨rpow_pos_of_pos hS _, ?_, ?_⟩
  · have := mul_pos (mul_pos (rpow_pos_of_pos hS (-(1 / r) - 1)) hy) (rpow_pos_of_pos hp₁ (r - 1))
    linarith
  · have := mul_pos (mul_pos (rpow_pos_of_pos hS (-(1 / r) - 1)) hy) (rpow_pos_of_pos hp₂ (r - 1))
    linarith