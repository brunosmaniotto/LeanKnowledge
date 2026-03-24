import Mathlib

open Set

variable {S₁ S₂ S₃ : Type}

def comp (R₁ : Set (S₁ × S₂)) (R₂ : Set (S₂ × S₃)) : Set (S₁ × S₃) :=
  { p | ∃ y, ((p.1, y) ∈ R₁ ∧ (y, p.2) ∈ R₂) }