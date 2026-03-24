import Mathlib

-- Cross product (determinant) for vectors in ℝ²
def cross (v w : ℝ × ℝ) : ℝ := v.1 * w.2 - v.2 * w.1