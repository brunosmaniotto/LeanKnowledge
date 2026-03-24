import Mathlib

open Set

variable {D : Type*}

def L (f : D → ℝ) (y0 : ℝ) : Set D := {x | f x = y0}