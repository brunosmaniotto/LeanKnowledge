import Mathlib

variable {S : Type} [Semigroup S] (a b c d : S)

theorem four_element_assoc : ((a * b) * c) * d = a * (b * (c * d)) := by
  calc
    ((a * b) * c) * d = (a * b) * (c * d) := by rw [mul_assoc]
    _ = a * (b * (c * d)) := by rw [mul_assoc]