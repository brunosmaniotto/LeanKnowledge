import Mathlib
open Set

def WOP : Prop := ∀ (s : Set ℕ), s.Nonempty → ∃ m ∈ s, ∀ n ∈ s, m ≤ n