import Mathlib

/-- A good is lumpy if it can only be purchased in whole units (0 or 1),
    not in fractional amounts. Models the assumption that fractional
    amounts of the full insurance policy can be neither purchased nor sold. -/
def IsLumpyGood (q : ℝ) : Prop := q = 0 ∨ q = 1