import Mathlib

theorem Product_is_Zero_Divisor_means_Zero_Divisor {R : Type} [Ring R] {x y : R}
    (h : ∃ (z : R), z ≠ 0 ∧ ((x * y) * z = 0 ∨ z * (x * y) = 0)) :
    (∃ (z : R), z ≠ 0 ∧ (x * z = 0 ∨ z * x = 0)) ∨ (∃ (z : R), z ≠ 0 ∧ (y * z = 0 ∨ z * y = 0)) := by
  rcases h with ⟨z, hz_ne_zero, hz⟩
  rcases hz with (h_left | h_right)
  · have h_assoc : x * (y * z) = 0 := by rwa [mul_assoc] at h_left
    by_cases h_yz : y * z = 0
    · right
      exact ⟨z, hz_ne_zero, Or.inl h_yz⟩
    · left
      exact ⟨y * z, h_yz, Or.inl h_assoc⟩
  · have h_assoc : (z * x) * y = 0 := by rwa [← mul_assoc] at h_right
    by_cases h_zx : z * x = 0
    · left
      exact ⟨z, hz_ne_zero, Or.inr h_zx⟩
    · right
      exact ⟨z * x, h_zx, Or.inr h_assoc⟩