import Mathlib

theorem unit_not_zero_divisor {R : Type _} [Ring R] {x : R} (hx : IsUnit x) : ¬∃ (y : R), y ≠ 0 ∧ (x * y = 0 ∨ y * x = 0) := by
  rintro ⟨y, hy, h⟩
  cases' h with h_left h_right
  · rcases hx with ⟨u, rfl⟩
    have : y = 0 := by
      calc
        y = 1 * y := by rw [one_mul]
        _ = ((u⁻¹ : Rˣ) * u : R) * y := by rw [Units.inv_mul]
        _ = (u⁻¹ : Rˣ) * (u * y) := by rw [mul_assoc]
        _ = (u⁻¹ : Rˣ) * 0 := by rw [h_left]
        _ = 0 := by rw [mul_zero]
    exact hy this
  · rcases hx with ⟨u, rfl⟩
    have : y = 0 := by
      calc
        y = y * 1 := by rw [mul_one]
        _ = y * (u * (u⁻¹ : Rˣ)) := by rw [Units.mul_inv]
        _ = (y * u) * (u⁻¹ : Rˣ) := by rw [mul_assoc]
        _ = 0 * (u⁻¹ : Rˣ) := by rw [h_right]
        _ = 0 := by rw [zero_mul]
    exact hy this