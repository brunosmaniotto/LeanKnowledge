import Mathlib

variable {R : Type} [Ring R] [IsDomain R]

theorem idempotent_eq_zero_or_one (x : R) : x * x = x ↔ x = 0 ∨ x = 1 := by
  constructor
  · intro h
    by_cases hx : x = 0
    · left; exact hx
    · right
      apply mul_left_cancel₀ hx
      rw [mul_one]
      exact h
  · rintro (rfl|rfl)
    · simp
    · simp