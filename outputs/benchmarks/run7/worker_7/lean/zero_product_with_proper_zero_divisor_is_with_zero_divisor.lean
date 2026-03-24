import Mathlib

variable {R : Type} [Ring R]

def IsZeroDivisor (a : R) : Prop := ∃ b ≠ 0, a * b = 0 ∨ b * a = 0