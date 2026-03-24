import Mathlib

-- Determinant for two vectors in ℝ²
def det2 (a b : ℝ × ℝ) : ℝ := a.1 * b.2 - a.2 * b.1

-- Area of triangle with vertices A, B, C