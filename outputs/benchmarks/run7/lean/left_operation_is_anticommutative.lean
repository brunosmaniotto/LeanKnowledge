import Mathlib

variable {α : Type}

/-- The left operation: returns its first argument. -/
def leftOp (x y : α) : α := x

-- Introduce the notation `x ← y` for `leftOp x y`
notation:50 x " ← " y => leftOp x y