import Mathlib

open Set

def line (a b c : ℝ) : Set (ℝ × ℝ) := { p | a * p.1 + b * p.2 = c }