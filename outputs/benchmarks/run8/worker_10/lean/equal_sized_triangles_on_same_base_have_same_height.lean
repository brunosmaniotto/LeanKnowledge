import Mathlib

noncomputable section

-- Define points as vectors in ℝ²
abbrev Point := EuclideanSpace ℝ (Fin 2)

-- Cross product in ℝ²
def cross (u v : Point) : ℝ := u 0 * v 1 - u 1 * v 0

-- Signed area of triangle ABC (half the cross product of (B-A) and (C-A))