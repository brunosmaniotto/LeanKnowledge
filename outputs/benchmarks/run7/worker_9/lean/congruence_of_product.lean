import Mathlib

open AddSubgroup

/-- Real numbers `a` and `b` are congruent modulo `z` if their difference is an integer multiple of `z`. -/
def Real.ModEq (a b z : ℝ) : Prop := a - b ∈ zmultiples z