import Mathlib

/-- Example 5B.1: A production vector for L = 5 commodities.
    Negative entries are inputs, positive entries are outputs, zero means unused.
    y = (−5, 2, −6, 3, 0): goods 1 and 3 are inputs (5 and 6 units),
    goods 2 and 4 are outputs (2 and 3 units), good 5 is unused. -/
def Example_5B1 : Fin 5 → ℤ :=
  ![(-5 : ℤ), 2, -6, 3, 0]