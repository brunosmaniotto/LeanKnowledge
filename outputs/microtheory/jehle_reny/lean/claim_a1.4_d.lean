import Mathlib

variable {D : Type*} (f : D → ℝ) (y₀ : ℝ)

def SuperiorSet : Set D := {x | y₀ ≤ f x}