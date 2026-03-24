import Mathlib

variable {S : Type} [Mul S] (c : Con S)

-- Define subset product operation
def subset_product (A B : Set S) : Set S := {z | ∃ x ∈ A, ∃ y ∈ B, z = x * y}

-- Define quotient operation