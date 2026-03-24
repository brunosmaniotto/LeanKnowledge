import Mathlib

theorem real_add_assoc (x y z : ℝ) : x + (y + z) = (x + y) + z :=
  (add_assoc x y z).symm