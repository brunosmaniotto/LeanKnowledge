import Mathlib

theorem real_mul_distrib (x y z : ℝ) :
    x * (y + z) = x * y + x * z ∧ (y + z) * x = y * x + z * x := by
  exact ⟨mul_add x y z, add_mul y z x⟩