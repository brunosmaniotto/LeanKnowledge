import Mathlib

open Set

def R : ℝ → ℝ → Prop := fun x y => Int.ceil x = Int.ceil y