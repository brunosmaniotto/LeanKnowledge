import Mathlib

/-- Congruence modulo `z` for real numbers: `x` and `y` are congruent modulo `z` if their
difference is an integer multiple of `z`. -/
def CongMod (z : ℝ) (x y : ℝ) : Prop := ∃ k : ℤ, x - y = (k : ℤ) * z