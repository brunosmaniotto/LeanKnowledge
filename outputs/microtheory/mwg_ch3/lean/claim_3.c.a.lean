import Mathlib

def lexPref (x y : ℝ × ℝ) : Prop :=
  x.1 > y.1 ∨ (x.1 = y.1 ∧ x.2 ≥ y.2)