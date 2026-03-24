import Mathlib

theorem brahmagupta_identity (a b c d : ℝ) :
    4 * (a * b + c * d)^2 - (a^2 + b^2 - c^2 - d^2)^2 =
      (-a + b + c + d) * (a - b + c + d) * (a + b - c + d) * (a + b + c - d) := by
  ring