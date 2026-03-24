import Mathlib

/-- The lexicographic preference relation on ℝ² (Example 3.C.1, MWG).
    `x ≿_L y` iff `x.1 > y.1`, or `x.1 = y.1` and `x.2 ≥ y.2`. -/
def lexicographicPref (x y : ℝ × ℝ) : Prop :=
  x.1 > y.1 ∨ (x.1 = y.1 ∧ x.2 ≥ y.2)