import Mathlib

variable {S : Type*}

/-- A constant binary operation on `S` returning a fixed element `c`. -/
def constOp (c : S) : S → S → S := fun _ _ => c