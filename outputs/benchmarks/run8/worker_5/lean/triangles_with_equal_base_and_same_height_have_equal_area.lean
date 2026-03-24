import Mathlib

open Real

-- Cross product in ℝ² (determinant)
def cross2 (u v : ℝ × ℝ) : ℝ := u.1 * v.2 - u.2 * v.1

-- Area of triangle ABC as half the absolute value of the cross product