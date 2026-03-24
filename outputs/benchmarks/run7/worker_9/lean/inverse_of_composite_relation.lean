import Mathlib

variable {S1 S2 S3 : Type _}

def comp (R1 : Set (S1 × S2)) (R2 : Set (S2 × S3)) : Set (S1 × S3) :=
  { p | ∃ y : S2, (p.1, y) ∈ R1 ∧ (y, p.2) ∈ R2 }