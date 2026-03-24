import Mathlib

-- Define `is_integer_real` for real numbers that are integers.
def is_integer_real (x : ℝ) : Prop := ∃ k : ℤ, x = ↑k

-- Define `is_natural_multiple` for when a real number is a natural multiple of another.
-- This represents the "integer multiples of q̄" for the supply correspondence.