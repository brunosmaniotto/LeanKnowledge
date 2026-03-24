import Mathlib

variable {S T : Type}

def dom (r : Set (S × T)) : Set S := {x | ∃ y, (x, y) ∈ r}