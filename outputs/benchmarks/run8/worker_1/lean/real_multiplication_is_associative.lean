import Mathlib

theorem real_mul_assoc (x y z : ℝ) : x * (y * z) = (x * y) * z :=
  (mul_assoc x y z).symm