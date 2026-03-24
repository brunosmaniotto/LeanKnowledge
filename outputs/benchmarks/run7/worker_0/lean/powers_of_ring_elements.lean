import Mathlib

variable {R : Type _} [Ring R]

theorem powers_of_ring_elements (n : ℤ) (x : R) : (n • x) * x = n • (x * x) ∧ n • (x * x) = x * (n • x) := by
  constructor
  · exact?
  · exact?