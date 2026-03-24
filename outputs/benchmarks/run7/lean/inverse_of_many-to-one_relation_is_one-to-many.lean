import Mathlib

variable {S T : Type}

def Dom (R : Rel S T) : Set S := {x | ∃ y, R x y}