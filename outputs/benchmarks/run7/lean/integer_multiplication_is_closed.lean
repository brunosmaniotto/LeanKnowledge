import Mathlib

open Set

theorem int_mul_closed : ∀ (a b : ℤ), a * b ∈ (univ : Set ℤ) := by
  intro a b
  exact mem_univ (a * b)