import Mathlib

/-- The rectangle with sides `a` and `b` is equal to the sum of the rectangle with sides `a - b` and `b`
and the square on `b`. -/
theorem rectangle_eq_sum_of_square_and_rectangle (a b : ℝ) : a * b = (a - b) * b + b ^ 2 := by
  ring