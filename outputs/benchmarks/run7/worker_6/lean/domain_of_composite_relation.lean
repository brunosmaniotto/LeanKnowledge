import Mathlib.Data.Set.Basic

variable {S₁ S₂ S₃ : Type}

def domain {α β} (R : Set (α × β)) : Set α := {a | ∃ b, (a, b) ∈ R}