import Mathlib
open Set

-- Define the relation: two reals are related if they have the same floor
def R : Set (ℝ × ℝ) := { p | ⌊p.1⌋ = ⌊p.2⌋ }

-- Prove R is an equivalence relation