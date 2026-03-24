import Mathlib

open Subfield

variable (K : Type) [DivisionRing K]

def divisionSubrings : Set (Subring K) :=
  { S | ∀ x ∈ S, x ≠ 0 → x⁻¹ ∈ S }