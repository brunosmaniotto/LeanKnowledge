import Mathlib

theorem exists_int_mul_identity : ∃ (x : ℤ), ∀ a : ℤ, a * x = a ∧ x * a = a := by
  use 1
  intro a
  exact ⟨Int.mul_one a, Int.one_mul a⟩